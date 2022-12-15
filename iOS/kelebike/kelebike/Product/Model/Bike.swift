class Bike: Decodable {
    
    var brand : String
    var code : Int
    var issuedDate : String
    var lock : Int
    var owner : String
    var returnDate : String
    var status : String
    
    init(code: Int, lock: Int, brand: String, issuedDate: String, returnDate: String, owner: String, status: String) {
        self.code = code
        self.lock = lock
        self.brand = brand
        self.issuedDate = issuedDate
        self.returnDate = returnDate
        self.owner = owner
        self.status = status
    }
}
