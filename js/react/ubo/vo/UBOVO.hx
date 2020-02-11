package react.ubo.vo;

typedef UboVOAddress = {
    AddressLine1: String,
    ?AddressLine2: String,
    City: String,
    PostalCode: String,
    Country: String,
    ?Region: String,
};

typedef UboVOBirthplace = {
    City: String,
    Country: String,
};

class UboVO {
    public var Id: Int;
    public var FirstName: String;
    public var LastName: String;
    public var Address: UboVOAddress;
    public var Nationality: String;
    public var Birthday: Int;
    public var Birthplace: UboVOBirthplace;

    public function new(
        Id: Int,
        FirstName: String,
        LastName: String,
        Address: UboVOAddress,
        Nationality: String,
        Birthday: Int,
        Birthplace: UboVOBirthplace
    ) {
        this.Id = Id;
        this.FirstName = FirstName;
        this.LastName = LastName;
        this.Address = Address;
        this.Nationality = Nationality;
        this.Birthday = Birthday;
        this.Birthplace = Birthplace;
    }

    static public function parse(data: Dynamic): UboVO {
        return new UboVO(
            data.Id,
            data.FirstName,
            data.LastName,
            {
                AddressLine1: data.Address.AddressLine1,
                AddressLine2: data.Address.AddressLine2,
                City: data.Address.City,
                PostalCode: data.Address.PostalCode,
                Country: data.Address.Country,
                Region: data.Address.Region
            },
            data.Nationality,
            data.Birthday,
            {
                City: data.Birthplace.City,
                Country: data.Birthplace.Country,
            }
        );
    }

    static public function parseArray(data: Dynamic): Array<UboVO> {
        return data.map(d -> parse(d));
    }
}