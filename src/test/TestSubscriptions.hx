package test;
import Common;
import utest.*;
import service.DistributionService;
import service.OrderService;
import service.SubscriptionService;
import service.SubscriptionService.SubscriptionServiceError;

/**
 * Test subscriptions
 * 
 * @author web-wizard
 */
class TestSubscriptions extends utest.Test
{
	
	public function new(){
		super();
	}
	
	var catalog : db.Catalog;
	var micheline : db.User;
	var botteOignons : db.Product;
	var panierAmap : db.Product;
	
	/**
	 * get a contract + a user + a product + empty orders
	 */
	function setup(){

		TestSuite.initDB();
		TestSuite.initDatas();

		catalog = TestSuite.CONTRAT_AMAP;

		botteOignons = TestSuite.BOTTE_AMAP;
		panierAmap = TestSuite.PANIER_AMAP_LEGUMES;

		micheline = db.User.manager.get(1);

	}

	/**
	Test Get subscription orders
	**/
	public function testSubscriptionOrders() {

		var subscription = new db.Subscription();
		subscription.user = micheline;
		subscription.catalog = catalog;
		subscription.startDate = catalog.startDate;
		subscription.endDate = catalog.endDate;
		subscription.insert();

		var distributions = db.Distribution.manager.search( $catalog == catalog && $date >= subscription.startDate && $end <= subscription.endDate );
		for ( distrib in distributions ) {
			OrderService.make( micheline, 3 , botteOignons,  distrib.id, false, subscription, null, false );
			OrderService.make( micheline, 2 , panierAmap,  distrib.id, false, subscription, null, false );
		}

		var subscriptionOrders = SubscriptionService.getSubscriptionOrders( subscription );

		Assert.equals( subscriptionOrders.length, 2 );
		var order1 = Lambda.array( subscriptionOrders )[0];
		var order2 = Lambda.array( subscriptionOrders )[1];
		Assert.equals( order1.product.id, botteOignons.id );
		Assert.equals( order1.quantity, 3 );
		Assert.equals( order2.product.id, panierAmap.id );
		Assert.equals( order2.quantity, 2 );

	}


	public function testDeleteSubscription() {

		DistributionService.create( catalog, new Date(2030, 5, 1, 19, 0, 0), new Date(2030, 5, 1, 20, 0, 0), TestSuite.PLACE_DU_VILLAGE.id, new Date(2030, 4, 1, 20, 0, 0), new Date(2030, 4, 30, 20, 0, 0) );
		DistributionService.create( catalog, new Date(2030, 6, 1, 19, 0, 0), new Date(2030, 6, 1, 20, 0, 0), TestSuite.PLACE_DU_VILLAGE.id, new Date(2030, 5, 1, 20, 0, 0), new Date(2030, 5, 30, 20, 0, 0) );

		//-----------------------------------------------
		//Test case : There are orders for past distribs
		//-----------------------------------------------
		var subscription = new db.Subscription();
		subscription.user = micheline;
		subscription.catalog = catalog;
		subscription.startDate = catalog.startDate;
		subscription.endDate = catalog.endDate;
		subscription.insert();

		var distributions = db.Distribution.manager.search( $catalog == catalog && $date >= subscription.startDate && $date <= subscription.endDate );
		for ( distrib in distributions ) {

			OrderService.make( micheline, 3 , botteOignons,  distrib.id, false, subscription, null, false );
			OrderService.make( micheline, 2 , panierAmap,  distrib.id, false, subscription, null, false );
		}

		
		Assert.equals( SubscriptionService.getSubscriptionOrders( subscription ).length, 2 );

		//Check : When trying to delete the subscription there should be an error because there are orders for past distributions
		var error1 = null;
		try {
			
			SubscriptionService.deleteSubscription( subscription );
		}
	    catch( e : tink.core.Error ) {

			error1 = e;
		}
		Assert.equals( error1.data, PastOrders );
		Assert.equals( SubscriptionService.getSubscriptionOrders( subscription ).length, 2 );

		//Test case : There are no past distribs
		//---------------------------------------
		subscription.lock();
		subscription.startDate = Date.now();
		subscription.update();

		Assert.equals( SubscriptionService.getSubscriptionOrders( subscription ).length, 2 );

		//Check : I can delete this subscription because thete are no orders for past distributions
		var error2 = null;
		var copiedSubscription = subscription;
		try {
			
			SubscriptionService.deleteSubscription( subscription );
		}
	    catch( e : tink.core.Error ) {

			error2 = e;
		}
		Assert.equals( error2, null );
		Assert.equals( SubscriptionService.getSubscriptionOrders( copiedSubscription ).length, 0 );

	}

	/**
	 *  Test subscription creation and cases that generate errors
	 	@author web-wizard
	 */
	function testCreateSubscription() {

		var bob = TestSuite.FRANCOIS;
		var catalog = TestSuite.CONTRAT_AMAP;
		var botteOignons = TestSuite.BOTTE_AMAP;
		var panierAmap = TestSuite.PANIER_AMAP_LEGUMES;
		var soupeAmap = TestSuite.SOUPE_AMAP;
		
		DistributionService.create( catalog, DateTools.delta( Date.now(), 1000.0 * 60 * 60 * 24 * 14 ), new Date(2030, 5, 1, 20, 0, 0), TestSuite.PLACE_DU_VILLAGE.id, new Date(2030, 4, 1, 20, 0, 0), new Date(2030, 4, 30, 20, 0, 0) );
		DistributionService.create( catalog, new Date(2030, 6, 1, 19, 0, 0), new Date(2030, 6, 1, 20, 0, 0), TestSuite.PLACE_DU_VILLAGE.id, new Date(2030, 5, 1, 20, 0, 0), new Date(2030, 5, 30, 20, 0, 0) );		

		var ordersData = new Array< { productId : Int, qt : Float, invertSharedOrder : Bool, userId2 : Int } >();
		ordersData.push( { productId : panierAmap.id, qt : 1, invertSharedOrder : false, userId2 : null } );
		var subscription : db.Subscription = null;
		var error = null;
		//Test case : Start and end dates are null
		//----------------------------------------
		try {
			
			subscription = SubscriptionService.createSubscription( bob, catalog, null, null, ordersData );
		}
		catch( e : tink.core.Error ) {

			error = e;
		}
		Assert.equals( error.message, 'La date de début et de fin de la souscription doivent être définies.' );
		Assert.equals( subscription, null );
		Assert.equals( db.Subscription.manager.count( $user == bob ), 0 );

		//Test case : Start date is outside catalog start and end dates
		//--------------------------------------------------------------
		try {
			
			subscription = SubscriptionService.createSubscription( bob, catalog, new Date(2000, 5, 1, 19, 0, 0), catalog.endDate, ordersData  );
		}
		catch( e : tink.core.Error ) {

			error = e;
		}
		Assert.equals( error.message, 'La date de début de la souscription doit être comprise entre les dates de début et de fin du catalogue.' );
		Assert.equals( subscription, null );
		Assert.equals( db.Subscription.manager.count( $user == bob ), 0 );

		//Test case : End date is outside catalog start and end dates
		//-----------------------------------------------------------
		try {
			
			subscription = SubscriptionService.createSubscription( bob, catalog, catalog.startDate, new Date(2036, 5, 1, 19, 0, 0), ordersData );
		}
		catch( e : tink.core.Error ) {

			error = e;
		}
		Assert.equals( error.message, 'La date de fin de la souscription doit être comprise entre les dates de début et de fin du catalogue.' );
		Assert.equals( subscription, null );
		Assert.equals( db.Subscription.manager.count( $user == bob ), 0 );
		
		//Test case : No orders data were given
		//--------------------------------------
		try {
			
			subscription = SubscriptionService.createSubscription( bob, catalog, new Date(2019, 5, 1, 19, 0, 0), catalog.endDate, null );
		}
		catch( e : tink.core.Error ) {

			error = e;
		}
		Assert.equals( error.message, 'Il n\'y a pas de commandes définies.' );
		Assert.equals( subscription, null );
		Assert.equals( db.Subscription.manager.count( $user == bob ), 0 );

		//Test case : User 2 not found
		//----------------------------
		ordersData = [ { productId : panierAmap.id, qt : 1, invertSharedOrder : false, userId2 : 999999 } ];
		try {
			
			subscription = SubscriptionService.createSubscription( bob, catalog, new Date(2019, 5, 1, 19, 0, 0), catalog.endDate, ordersData );
		}
		catch( e : tink.core.Error ) {

			error = e;
		}
		Assert.equals( error.message, "Unable to find user #999999" );
		Assert.equals( subscription, null );
		Assert.equals( db.Subscription.manager.count( $user == bob ), 0 );

		//Test case : Same User 2
		//-----------------------
		ordersData = [ { productId : panierAmap.id, qt : 1, invertSharedOrder : false, userId2 : bob.id } ];
		try {
			
			subscription = SubscriptionService.createSubscription( bob, catalog, new Date(2019, 5, 1, 19, 0, 0), catalog.endDate, ordersData );
		}
		catch( e : tink.core.Error ) {

			error = e;
		}
		Assert.equals( error.message, 'Both selected accounts must be different ones' );
		Assert.equals( subscription, null );
		Assert.equals( db.Subscription.manager.count( $user == bob ), 0 );

		//Test case : Successfully creating a subscription
		//------------------------------------------------
		var ordersData = new Array< { productId : Int, qt : Float, invertSharedOrder : Bool, userId2 : Int } >();
		ordersData.push( { productId : botteOignons.id, qt : 3, invertSharedOrder : false, userId2 : null } );
		ordersData.push( {  productId : panierAmap.id, qt : 2, invertSharedOrder : false, userId2 : null } );
		try {
			
			subscription = SubscriptionService.createSubscription( bob, catalog, catalog.startDate, catalog.endDate, ordersData );
			//subscription = SubscriptionService.createSubscription( bob, catalog, new Date(2019, 5, 1, 19, 0, 0), catalog.endDate, ordersData );
		}
		catch( e : tink.core.Error ) {

			error = e;
		}
		// Assert.equals( error, null );
		// Assert.isTrue( subscription != null );
		// Assert.equals( db.Subscription.manager.count( $user == bob ), 1 );

		// var subscriptionDistributions = SubscriptionService.getSubscriptionDistributions( subscription );
		// for ( distribution in subscriptionDistributions ) {

		// 	var distribOrders = db.UserOrder.manager.search( $user == bob && $subscription == subscription && $distribution == distribution, false );
		// 	Assert.equals( distribOrders.length, 2 );
		// 	var order1 = Lambda.array( distribOrders )[0];
		// 	var order2 = Lambda.array( distribOrders )[1];
		// 	Assert.equals( order1.product.id, botteOignons.id );
		// 	Assert.equals( order1.quantity, 3 );
		// 	Assert.equals( order2.product.id, panierAmap.id );
		// 	Assert.equals( order2.quantity, 2 );
		// }

		// var subscriptionOrders = SubscriptionService.getSubscriptionOrders( subscription );

		// Assert.equals( subscriptionOrders.length, 2 );
		// var order1 = Lambda.array( subscriptionOrders )[0];
		// var order2 = Lambda.array( subscriptionOrders )[1];
		// Assert.equals( order1.product.id, botteOignons.id );
		// Assert.equals( order1.quantity, 3 );
		// Assert.equals( order2.product.id, panierAmap.id );
		// Assert.equals( order2.quantity, 2 );

		//----------------------------------------------------------------------------------------
		// var subscription : db.Subscription = null;
		// var error1 = null;
		// try {
			
		// 	subscription = SubscriptionService.createSubscription( bob, catalog, catalog.startDate, catalog.endDate );
		// }
	    // catch( e : tink.core.Error ) {

		// 	error1 = e;
		// }
		// Assert.equals( error1.data, PastDistributionsWithoutOrders );

		// var error2 = null;
		// try {

		// 	subscription = SubscriptionService.createSubscription( bob, catalog, new Date(2019, 5, 1, 19, 0, 0), catalog.endDate );
		// }
	    // catch( e : tink.core.Error ) {

		// 	error2 = e;
		// }
		// Assert.equals( error2, null );

		// var ordersData = new Array< { id : Int, productId : Int, qt : Float, paid : Bool, invertSharedOrder : Bool, userId2 : Int } >();
		// ordersData.push( { id : null, productId : botteOignons.id, qt : 3, paid : false, invertSharedOrder : false, userId2 : null } );
		// ordersData.push( { id : null, productId : panierAmap.id, qt : 2, paid : false, invertSharedOrder : false, userId2 : null } );
		// OrderService.createOrUpdateOrders( bob, null, catalog, ordersData );

		// var subscriptionDistributions = SubscriptionService.getSubscriptionDistributions( subscription );
		// for ( distribution in subscriptionDistributions ) {

		// 	var distribOrders = db.UserOrder.manager.search( $user == bob && $subscription == subscription && $distribution == distribution, false );
		// 	Assert.equals( distribOrders.length, 2 );
		// 	var order1 = Lambda.array( distribOrders )[0];
		// 	var order2 = Lambda.array( distribOrders )[1];
		// 	Assert.equals( order1.product.id, botteOignons.id );
		// 	Assert.equals( order1.quantity, 3 );
		// 	Assert.equals( order2.product.id, panierAmap.id );
		// 	Assert.equals( order2.quantity, 2 );
		// }

		// var subscriptionOrders = SubscriptionService.getSubscriptionOrders( subscription );

		// Assert.equals( subscriptionOrders.length, 2 );
		// var order1 = Lambda.array( subscriptionOrders )[0];
		// var order2 = Lambda.array( subscriptionOrders )[1];
		// Assert.equals( order1.product.id, botteOignons.id );
		// Assert.equals( order1.quantity, 3 );
		// Assert.equals( order2.product.id, panierAmap.id );
		// Assert.equals( order2.quantity, 2 );

		// //Je modifie une commande existante mais je n'ai pas le droit
		// var ordersData = new Array< { id : Int, productId : Int, qt : Float, paid : Bool, invertSharedOrder : Bool, userId2 : Int } >();
		// ordersData.push( { id : null, productId : panierAmap.id, qt : 3, paid : false, invertSharedOrder : false, userId2 : null } );
		// ordersData.push( { id : null, productId : soupeAmap.id, qt : 2, paid : false, invertSharedOrder : false, userId2 : null } );
		// var error = null;
		// try {

		// 	OrderService.createOrUpdateOrders( bob, null, catalog, ordersData );
		// }
	    // catch( e : tink.core.Error ) {

		// 	error = e;
		// }
		// Assert.equals( error, null );

		// //Je modifie la date de fin de la souscription pour recréer une nouvelle souscription et ajouter des orders
		// var subscriptionDistributions = SubscriptionService.getSubscriptionDistributions( subscription );
		// for ( distribution in subscriptionDistributions ) {

		// 	var distribOrders = db.UserOrder.manager.search( $user == bob && $subscription == subscription && $distribution == distribution, false );
		// 	Assert.equals( distribOrders.length, 2 );
		// 	var order1 = Lambda.array( distribOrders )[0];
		// 	var order2 = Lambda.array( distribOrders )[1];
		// 	Assert.equals( order1.product.id, panierAmap.id );
		// 	Assert.equals( order1.quantity, 3 );
		// 	Assert.equals( order2.product.id, soupeAmap.id );
		// 	Assert.equals( order2.quantity, 2 );
		// }

		// var subscriptionOrders = SubscriptionService.getSubscriptionOrders( subscription );

		// Assert.equals( subscriptionOrders.length, 2 );
		// var order1 = Lambda.array( subscriptionOrders )[0];
		// var order2 = Lambda.array( subscriptionOrders )[1];
		// Assert.equals( order1.product.id, panierAmap.id );
		// Assert.equals( order1.quantity, 3 );
		// Assert.equals( order2.product.id, soupeAmap.id );
		// Assert.equals( order2.quantity, 2 );

	}

}