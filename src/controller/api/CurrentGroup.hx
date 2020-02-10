package controller.api;

/**
 * api for current group
 * ROUTE: api/currentgroup/*
 * TODO: Change currentgroup by :groupId 
 */
class CurrentGroup extends Controller {

  #if plugins
    /*
     * PLUGIN
     * ROUTE: api/currentgroup/mangopay/*
    */
    public function doMangopay(d:haxe.web.Dispatch) {
      d.dispatch(new mangopay.controller.api.currentgroup.CurrentGroup());
    }
  #end

}