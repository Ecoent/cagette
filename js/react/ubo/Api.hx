package react.ubo;

class Api {
    static private  var iso3166French: Dynamic;

    public static function fetchDeclarations() {
        return js.Browser.window.fetch("/api/currentgroup/mangopay/kyc/ubodeclarations").then(res -> {
            if (!res.ok) {
                throw res.statusText;
            }
            return res.json();
        });
    }

    public static function postOrPutUbo(data: js.html.FormData, declarationId: Int, ?uboId: Int): js.Promise<Dynamic> {
        var url = '/api/currentgroup/mangopay/kyc/ubodeclarations/${declarationId}/ubos/';
        if (uboId != null) url += Std.string(uboId);

        return js.Browser.window.fetch(
            url,
            {
                method: uboId == null ? "POST" : "PUT",
                body: data
            }
        ).then(res -> {
            if (!res.ok) {
                throw res.statusText;
            }
            return res.json();
        });
    }

    public static function fetchOnceISO3166French() {
        if (Api.iso3166French != null) {
            return new js.Promise<Dynamic>(function(resolve: Dynamic->Void, reject:Dynamic->Void) {
                resolve(Api.iso3166French);
            });
        }
            
        return js.Browser.window.fetch("/data/iso-3166-french.json")
            .then(res -> {
                if (!res.ok) {
                    throw res.statusText;
                }
                return res.json();
            }).then(res -> {
                Api.iso3166French = res;
                return res;
            });
    }
}