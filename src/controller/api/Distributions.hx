package controller.api;
import haxe.DynamicAccess;
import service.TimeSlotsService;
import tink.core.Error;
import db.UserGroup;
import haxe.Json;
import Common;
import db.MultiDistrib;

/**
 * Groups API
 * @author fbarbut
 */
class Distributions extends Controller {

  private var distrib: db.MultiDistrib;

  public function new(distrib: db.MultiDistrib) {
    super();
    this.distrib = distrib;
  }

  public function doSlots(d:haxe.web.Dispatch) {
		d.dispatch(new controller.api.DistributionsSlots(distrib));
	}	

  private function checkAdminRights(){
    if (!App.current.user.isAmapManager() || app.user.getGroup().id!=this.distrib.getGroup().id){
      throw new tink.core.Error(403, "Forbidden");
    } 
  }
  
  private function checkIsGroupMember(){
    
    // user must be logged
    if (app.user == null) throw new tink.core.Error(403, "Forbidden");
    
    // user must be member of group
    if(UserGroup.get(app.user,distrib.getGroup())==null){
      throw new tink.core.Error(403, "User is not member of this group");
    }
  }

  private function checkOrdersAreOpen() {
    var now = Date.now();
    if(distrib.orderEndDate==null || !(distrib.orderStartDate.getTime() < now.getTime() && distrib.orderEndDate.getTime() > now.getTime()) ){
      throw new Error(403,"Orders are not open");
    }
  }

  public function doDefault() {
    if (sugoi.Web.getMethod() != "GET") throw new tink.core.Error(405, "Method Not Allowed");
    checkIsGroupMember();
    Sys.print(Json.stringify(this.parse()));
  }

  /**
    an admin updates the slots
  **/
  public function doActivateSlots() {
    if (sugoi.Web.getMethod() != "POST") throw new tink.core.Error(405, "Method Not Allowed");
    checkAdminRights();
    checkOrdersAreOpen();
    
    if (this.distrib.slots != null) {
      Sys.print(Json.stringify(this.parse()));
      return;
    }
	var s = new TimeSlotsService(this.distrib);
    s.generateSlots();    
    Sys.print(Json.stringify(this.parse()));
  }

  public function doResolved() {
    if (sugoi.Web.getMethod() != "GET") throw new tink.core.Error(405, "Method Not Allowed");
    checkAdminRights();

    if (this.distrib.slots == null) {
      Sys.print(Json.stringify(this.parse()));
      return;
    }

    var now = Date.now();
    
    if(distrib.orderEndDate==null || distrib.orderEndDate.getTime() > now.getTime()){
      Sys.print(Json.stringify(this.parse()));
      return;
    }

    var it = this.distrib.inNeedUserIds.keys();
    var inNeedUserIds = new Array<Int>();
    while (it.hasNext()) {
      inNeedUserIds.push(it.next());
    }
    var inNeedUsers = db.User.manager.search($id in inNeedUserIds, false).array();

    var userIds = Lambda.fold(this.distrib.slots, (slot, acc: Array<Int>) -> {
      return Lambda.fold(slot.selectedUserIds, (userId, acc2: Array<Int>) -> {
        if (acc2.indexOf(userId) == -1) acc2.push(userId);
        return acc2;
      }, acc);
    }, new Array<Int>());
    var users = db.User.manager.search($id in userIds, false).array();

    var it = this.distrib.voluntaryUsers.keyValueIterator();
    var voluntaryMap = new haxe.DynamicAccess();
    while (it.hasNext()) {
      var v = it.next();
      voluntaryMap.set(Std.string(v.key), v.value);
    }

    var otherUsers =  this.distrib.getOrders().filter(userOrder -> {
      var founded = users.find(u -> u.id == userOrder.user.id);
      if (founded != null) return false;
      founded = inNeedUsers.find(u -> u.id == userOrder.user.id);
      if (founded != null) return false;
      return true;
    });

    Sys.print(Json.stringify({
      id: this.distrib.id,
      start: this.distrib.distribStartDate,
      end: this.distrib.distribEndDate,
      orderEndDate: this.distrib.orderEndDate,
      slots: this.distrib.slots,
      voluntaryMap: voluntaryMap,
      otherUsers: otherUsers.map(userOrder -> ({
        id: userOrder.user.id,
        firstName: userOrder.user.firstName,
        lastName: userOrder.user.lastName,
      })),
      users: users.map(user -> ({
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
      })),
      inNeedUsers: inNeedUsers.map(user -> {
        var data: Dynamic =  {
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
        }
        if (this.distrib.inNeedUserIds.get(user.id).indexOf("address") != -1) {
          data.address1 = user.address1;
          data.address2 = user.address2;
          data.city = user.city;
          data.zipCode = user.zipCode;
        }
        if (this.distrib.inNeedUserIds.get(user.id).indexOf("email") != -1) {
          data.email = user.email;
        }
        if (this.distrib.inNeedUserIds.get(user.id).indexOf("phone") != -1) {
          data.phone = user.phone;
        }
        return data;
      })
    }));
  }

  // TODO: remove
  @admin
  public function doResolve() {
    this.distrib.resolveSlots();
    Sys.print(Json.stringify(this.parse()));
  }

   // TODO: remove
  @admin
  public function doCloseDistrib() {
    this.distrib.lock();
    this.distrib.orderEndDate = DateTools.delta(Date.now(), -(1000 * 60 * 60 * 24));
    this.distrib.update();
    Sys.print(Json.stringify(this.parse()));
  }

   // TODO: remove
   @admin
  public function doDesactivateSlots() {
    this.distrib.lock();
    this.distrib.slots = null;
    this.distrib.inNeedUserIds = null;
    this.distrib.voluntaryUsers = null;
    this.distrib.orderEndDate  = DateTools.delta(Date.now(), 1000 * 60 * 60 * 24);
    this.distrib.update();
    Sys.print(Json.stringify(this.parse()));
  }

  // TODO: remove
  @admin
  public function doRegisterVoluntaryForMe() {

    var userId = App.current.user.id;
    var s = new TimeSlotsService(this.distrib);
    s.registerInNeedUser(userId, ["email"]);
    s.registerVoluntary(1, [55875]);
    
    Sys.print(Json.stringify(this.parse()));
  }

  // TODO : remove
  @admin
  public function doGenerateFakeDatas() {
    var fakeUserIds = [1, 2, 6, 8, 9];

    var s = new TimeSlotsService(this.distrib);
    this.distrib.lock();
    this.distrib.slots = null;
    this.distrib.inNeedUserIds = null;
    this.distrib.voluntaryUsers = null;
    this.distrib.orderEndDate  = DateTools.delta(Date.now(), 1000 * 60 * 60 * 24);
    this.distrib.update();

    s.generateSlots();
    s.registerUserToSlot(1, [1, 2]);

    for (userIndex in 1...fakeUserIds.length) {
      var slotIds = new Array<Int>();
      for (slotIndex in 0...this.distrib.slots.length) {
        var slot = this.distrib.slots[slotIndex];
        if (Math.random() > 0.7) {
          slotIds.push(slot.id);
        }
      }
      s.registerUserToSlot(fakeUserIds[userIndex], slotIds);
    }
    
    s.registerInNeedUser(10, ["email"]);
    s.registerInNeedUser(12, ["email", "address", "phone"]);
    s.registerInNeedUser(11, ["email", "address", "phone"]);
    s.registerInNeedUser(15, ["address"]);
    s.registerInNeedUser(17, ["phone"]);

    // s.registerUserToSlot(55875, [0, 1]);
	  // s.registerVoluntary(55875, [10, 11]);

    Sys.print(Json.stringify(this.parse()));
  }

  private function parse() {
    var users = new Array();

    if (this.distrib.inNeedUserIds != null) {

      // on récupère la liste des userInNeedIds
      var inNeedUserIds = new Array<Int>();
      var it = this.distrib.inNeedUserIds.keyValueIterator();
      while (it.hasNext()) {
        var v = it.next();
        inNeedUserIds.push(v.key);
        // inNeedUserIds = inNeedUserIds.filter(ui -> ui != v.key);
      }

      // que l'on filtre avec ceux déjà servis
      var it = this.distrib.voluntaryUsers.keyValueIterator();
      while (it.hasNext()) {
        var v = it.next();
        inNeedUserIds = inNeedUserIds.filter(userId ->v.value.indexOf(userId) == -1);
      }

      // que l'on transforme avec les datas aurtorisées
      for (i in 0...inNeedUserIds.length) {
        var user = db.User.manager.select($id == inNeedUserIds[i]);
        var userData: Dynamic = {
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
        };
        if (this.distrib.inNeedUserIds.get(user.id).indexOf("address") != -1) {
          userData.address1 = user.address1;
          userData.address2 = user.address2;
          userData.city = user.city;
          userData.zipCode = user.zipCode;
        }
        users.push(userData);
      }
    };

    return {
      id: this.distrib.id,
      start: this.distrib.distribStartDate,
      end: this.distrib.distribEndDate,
      orderEndDate: this.distrib.orderEndDate,
      slots: this.distrib.slots,
      inNeedUsers: users
    }
  }
}