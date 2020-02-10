package react.ubo.vo;

import react.ubo.vo.UBOVO;

enum UBODeclarationVOStatus {
    CREATED;
    VALIDATION_ASKED;
    INCOMPLETE;
    VALIDATED;
    REFUSED;
}

enum UBODeclarationVOReason {
    MISSING_UBO;
    WRONG_UBO_INFORMATION;
    UBO_IDENTITY_NEEDED;
    SHAREHOLDERS_DECLARATION_NEEDED;
    ORGANIZATION_CHART_NEEDED;
    DOCUMENTS_NEEDED;
    DECLARATION_DO_NOT_MATCH_UBO_INFORMATION;
    SPECIFIC_CASE;
}

class UBODeclarationVO {
    public var Id: Int;
    public var CreationDate: Int;
    public var ProcessedDate: Int;
    public var Status: UBODeclarationVOStatus;
    public var Reason: UBODeclarationVOReason;
    public var Message: String;
    public var Ubos: Array<UBOVO>;

    public function new(
        Id: Int,
        CreationDate: Int,
        ProcessedDate: Int,
        Status: UBODeclarationVOStatus,
        Reason: UBODeclarationVOReason,
        ?Message: String,
        Ubos: Array<UBOVO>
    ) {
        this.Id = Id;
        this.CreationDate = CreationDate;
        this.ProcessedDate = ProcessedDate;
        this.Status = Status;
        this.Reason = Reason;
        this.Message = Message;
        this.Ubos = Ubos;
    }

    static public function parse(data: Dynamic): UBODeclarationVO {
        return new UBODeclarationVO(
            data.Id,
            data.CreationDate,
            data.ProcessedDate,
            parseStatus(data.Status),
            parseReason(data.Reason),
            data.Message,
            UBOVO.parseArray(data.Ubos)
        );
    }

    static public function parseArray(data: Dynamic): Array<UBODeclarationVO> {
        return data.map(d -> parse(d));
    }

    static public function parseStatus(data: String): UBODeclarationVOStatus {
        return switch (data) {
            case "CREATED": UBODeclarationVOStatus.CREATED;
            case "VALIDATION_ASKED": UBODeclarationVOStatus.VALIDATION_ASKED;
            case "INCOMPLETE": UBODeclarationVOStatus.INCOMPLETE;
            case "VALIDATED": UBODeclarationVOStatus.VALIDATED;
            default: UBODeclarationVOStatus.REFUSED;
        }
    }

    static public function parseReason(data: String): UBODeclarationVOReason {
        return switch (data) {
            case "MISSING_UBO":  UBODeclarationVOReason.MISSING_UBO;
            case "WRONG_UBO_INFORMATION":  UBODeclarationVOReason.WRONG_UBO_INFORMATION;
            case "UBO_IDENTITY_NEEDED":  UBODeclarationVOReason.UBO_IDENTITY_NEEDED;
            case "SHAREHOLDERS_DECLARATION_NEEDED":  UBODeclarationVOReason.SHAREHOLDERS_DECLARATION_NEEDED;
            case "ORGANIZATION_CHART_NEEDED":  UBODeclarationVOReason.ORGANIZATION_CHART_NEEDED;
            case "DOCUMENTS_NEEDED":  UBODeclarationVOReason.DOCUMENTS_NEEDED;
            case "DECLARATION_DO_NOT_MATCH_UBO_INFORMATION":  UBODeclarationVOReason.DECLARATION_DO_NOT_MATCH_UBO_INFORMATION;
            default: UBODeclarationVOReason.SPECIFIC_CASE;
        }
    }
}