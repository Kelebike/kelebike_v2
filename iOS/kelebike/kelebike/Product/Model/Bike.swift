class Bike {
    
    var code : Int
    var lock : Int
    var brand : String
    var issuedDate : String
    var returnDate : String
    var owner : String
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
