package react.ubo.vo;

typedef UBOVOAddress = {
    AddressLine1: String,
    ?AddressLine2: String,
    City: String,
    PostalCode: String,
    Country: String,
    ?Region: String,
};

typedef UBOVOBirthplace = {
    City: String,
    Country: String,
};

class UBOVO {
    public var Id: Int;
    public var FirstName: String;
    public var LastName: String;
    public var Address: UBOVOAddress;
    public var Nationality: String;
    public var Birthday: Int;
    public var Birthplace: UBOVOBirthplace;

    public function new(
        Id: Int,
        FirstName: String,
        LastName: String,
        Address: UBOVOAddress,
        Nationality: String,
        Birthday: Int,
        Birthplace: UBOVOBirthplace
    ) {
        this.Id = Id;
        this.FirstName = FirstName;
        this.LastName = LastName;
        this.Address = Address;
        this.Nationality = Nationality;
        this.Birthday = Birthday;
        this.Birthplace = Birthplace;
    }

    static public function parse(data: Dynamic): UBOVO {
        return new UBOVO(
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

    static public function parseArray(data: Dynamic): Array<UBOVO> {
        return data.map(d -> parse(d));
    }
}