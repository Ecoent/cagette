package react.ubo;

class Api {
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

    public static function createDeclaration() {
        var url = '/api/currentgroup/mangopay/kyc/ubodeclarations';
        return js.Browser.window.fetch(
            url,
            {
                method: "POST",
            }
        ).then(res -> {
            if (!res.ok) {
                throw res.statusText;
            }
            return res.json();
        });
    }

    public static function updateDeclaration(declarationId: Int) {
        var url = '/api/currentgroup/mangopay/kyc/ubodeclarations/$declarationId';
        var data = new js.html.FormData();
        data.append("Status", "VALIDATION_ASKED");

        return js.Browser.window.fetch(
            url,
            {
                method: "PUT",
                body: data
            }
        ).then(res -> {
            if (!res.ok) {
                throw res.statusText;
            }
            return res.json();
        });
    }

    public static function fetchISO3166French() {
        return js.Browser.window.fetch("/data/iso-3166-french.json")
            .then(res -> {
                if (!res.ok) {
                    throw res.statusText;
                }
                return res.json();
            });
    }
}