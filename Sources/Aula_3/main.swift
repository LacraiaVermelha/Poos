import Foundation

class cofre {
    private var id:Int
    private var nome:String
    private var saldo:Double
    private var limite:Double

    init(_ nome:String,_  id:Int) {
        self.id = id
        self.nome = nome
        self.saldo = 0.0
        self.limite = 0.0
    }

    public func depositar(_ quantia: Double) {
        if (quantia > 0) {
            saldo += quantia
        }
        else {
            print("ERRO. Valor inválido.")
        }
    }

    public func sacar(_ quantia: Double) {
        if (quantia <= 0) {
            print("ERRO. Valor inválido.")
        }
        else if (saldo-quantia < limite) {
            print("ERRO. Saldo insuficiente.")
        }
        else {
            saldo -= quantia
        }
    }

    public func setLimite(_ novoLimite: Double) {
        if (novoLimite > 0) {
            print("ERRO. Limite de crédito deve ser menor que zero.")
        }
        else {
            limite = novoLimite
        }
    }

    public func getSaldo() -> Double {
        return saldo
    }
}

var conta = cofre.init("CARLOS", 01)
conta.setLimite(-10)
conta.sacar(10)
print(conta.getSaldo())