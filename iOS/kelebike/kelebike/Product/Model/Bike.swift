class Bike {
    
    var brand : String
    var code : String
    var issuedDate : String
    var lock : String
    var owner : String
    var returnDate : String
    var status : String
    
    init(code: String, lock: String, brand: String, issuedDate: String, returnDate: String, owner: String, status: String) {
        self.code = code
        self.lock = lock
        self.brand = brand
        self.issuedDate = issuedDate
        self.returnDate = returnDate
        self.owner = owner
        self.status = status
    }
    
}
