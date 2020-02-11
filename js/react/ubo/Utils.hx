package react.ubo;

import js.html.FormData;

class Utils {
    static public function addUboFormValuesToFormData(values: Dynamic, ?formData: FormData) {
        var data = formData == null ? new FormData() : formData;

        data.append("FirstName", values.FirstName);
        data.append("LastName", values.LastName);
        data.append("Address.AddressLine1", values.Address.AddressLine1);
        if (values.Address.AddressLine2 != null) data.append("Address.AddressLine2", values.Address.AddressLine2);
        data.append("Address.City", values.Address.City);
        data.append("Address.PostalCode", values.Address.PostalCode);
        data.append("Address.Country", values.Address.Country);
        if (values.Address.Region != null) data.append("Address.Region", values.Address.Region);
        data.append("Nationality", values.Nationality);
        data.append("Birthday", Std.string(values.Birthday.getTime() / 1000));
        data.append("Birthplace.City", values.Birthplace.City);
        data.append("Birthplace.Country", values.Birthplace.Country);

        return data;
    }
}