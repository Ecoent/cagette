package react.ubo.vo;

import react.ubo.vo.UboVO;

enum DeclarationVOStatus {
    CREATED;
    VALIDATION_ASKED;
    INCOMPLETE;
    VALIDATED;
    REFUSED;
}

enum DeclarationVOReason {
    MISSING_UBO;
    WRONG_UBO_INFORMATION;
    UBO_IDENTITY_NEEDED;
    SHAREHOLDERS_DECLARATION_NEEDED;
    ORGANIZATION_CHART_NEEDED;
    DOCUMENTS_NEEDED;
    DECLARATION_DO_NOT_MATCH_UBO_INFORMATION;
    SPECIFIC_CASE;
}

class DeclarationVO {
    public var Id: Int;
    public var CreationDate: Int;
    public var ProcessedDate: Int;
    public var Status: DeclarationVOStatus;
    public var Reason: DeclarationVOReason;
    public var Message: String;
    public var Ubos: Array<UboVO>;

    public function new(
        Id: Int,
        CreationDate: Int,
        ProcessedDate: Int,
        Status: DeclarationVOStatus,
        Reason: DeclarationVOReason,
        ?Message: String,
        Ubos: Array<UboVO>
    ) {
        this.Id = Id;
        this.CreationDate = CreationDate;
        this.ProcessedDate = ProcessedDate;
        this.Status = Status;
        this.Reason = Reason;
        this.Message = Message;
        this.Ubos = Ubos;
    }

    static public function parse(data: Dynamic): DeclarationVO {
        return new DeclarationVO(
            data.Id,
            data.CreationDate,
            data.ProcessedDate,
            parseStatus(data.Status),
            parseReason(data.Reason),
            data.Message,
            UboVO.parseArray(data.Ubos)
        );
    }

    static public function parseArray(data: Dynamic): Array<DeclarationVO> {
        return data.map(d -> parse(d));
    }

    static public function parseStatus(data: String): DeclarationVOStatus {
        return switch (data) {
            case "CREATED": DeclarationVOStatus.CREATED;
            case "VALIDATION_ASKED": DeclarationVOStatus.VALIDATION_ASKED;
            case "INCOMPLETE": DeclarationVOStatus.INCOMPLETE;
            case "VALIDATED": DeclarationVOStatus.VALIDATED;
            default: DeclarationVOStatus.REFUSED;
        }
    }

    static public function parseReason(data: String): DeclarationVOReason {
        return switch (data) {
            case "MISSING_UBO":  DeclarationVOReason.MISSING_UBO;
            case "WRONG_UBO_INFORMATION":  DeclarationVOReason.WRONG_UBO_INFORMATION;
            case "UBO_IDENTITY_NEEDED":  DeclarationVOReason.UBO_IDENTITY_NEEDED;
            case "SHAREHOLDERS_DECLARATION_NEEDED":  DeclarationVOReason.SHAREHOLDERS_DECLARATION_NEEDED;
            case "ORGANIZATION_CHART_NEEDED":  DeclarationVOReason.ORGANIZATION_CHART_NEEDED;
            case "DOCUMENTS_NEEDED":  DeclarationVOReason.DOCUMENTS_NEEDED;
            case "DECLARATION_DO_NOT_MATCH_UBO_INFORMATION":  DeclarationVOReason.DECLARATION_DO_NOT_MATCH_UBO_INFORMATION;
            default: DeclarationVOReason.SPECIFIC_CASE;
        }
    }
}