import Foundation

class user {
    var nome: String
    var email: String

    init(_ nome:String, _ email:String) {
        self.nome = nome
        self.email = email
    }

    func getDescription() {
        print("Usuário: \(nome), email: \(email)")
    }
}

class aluno: user {
    let matricula:Int
    let pagamento:tipoPagamento

    public enum tipoPagamento {
        case mensal, anual
    }

    init(_ nome:String, _ email:String, _ matricula:Int, _ pagamento:tipoPagamento) {
        self.matricula = matricula
        self.pagamento = pagamento
        super.init(nome, email)
    }
}

let joao = user("Jorge", "jorgeemail@email.com")
let carlos = user("Carlos", "carlosemail@email.com")