package react.ubo;

import js.html.FormData;
import react.ubo.vo.DeclarationVO;

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

    static public function declaration(declaration: DeclarationVO) {
        return {
            getAlertServerity: () -> {
                return switch (declaration.Status) {
                    case CREATED: "info";
                    case VALIDATION_ASKED: "info";
                    case INCOMPLETE: "warning";
                    case VALIDATED: "success";
                    case REFUSED: "error";
                };
            },
            getAlertTitle: (dateStr: String) -> {
                return switch (declaration.Status) {
                    case CREATED: 'Complétez la déclaration.';
                    case VALIDATION_ASKED: 'Déclaration du $dateStr en attente de validation.';
                    case INCOMPLETE: 'Déclaration du $dateStr incomplète.';
                    case VALIDATED: 'Déclaration du $dateStr acceptée.';
                    case REFUSED: 'Déclaration du $dateStr refusée.';
                };
            },
            canBeSubmitted: () -> {
                return switch (declaration.Status) {
                    case CREATED: true;
                    case VALIDATION_ASKED: false;
                    case INCOMPLETE: true;
                    case VALIDATED: false;
                    case REFUSED: false;
                };
            },
            canCreateNew: () -> {
                return switch (declaration.Status) {
                    case CREATED: false;
                    case VALIDATION_ASKED: false;
                    case INCOMPLETE: false;
                    case VALIDATED: true;
                    case REFUSED: true;
                };
            },
            canBeExtended: () -> {
                return switch (declaration.Status) {
                    case CREATED: true;
                    case VALIDATION_ASKED: true;
                    case INCOMPLETE: true;
                    case VALIDATED: true;
                    case REFUSED: true;
                };
            },
            ubosCanBeEdited: () -> {
                return switch (declaration.Status) {
                    case CREATED: true;
                    case VALIDATION_ASKED: false;
                    case INCOMPLETE: true;
                    case VALIDATED: false;
                    case REFUSED: false;
                };
            }
        };
    }
}