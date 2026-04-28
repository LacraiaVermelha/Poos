import Foundation

enum Nivel:String {
    case iniciante = "Iniciante", intermediario = "Intermediário", avancado = "Avançado"
}

enum Senioridade:String {
    // É útil ter uma maneira de medir o quão a academia confia em um trainer em particular. Isso pode ser regido por nível de 
    // especialização ou tempo de emprego
    case junior = "Junior", pleno = "Pleno", senior = "Senior"
}

enum Categorias:String {
    case musculacao = "Musculação", spinning = "Spinning", yoga = "Yoga", funcional = "Funcional", luta = "Luta", pilates = "Pilates"
}

class User {
    // O CPF é ótimo para uma chave principal imutavel que todo mundo teme sem criar um número arbitrário
    let cpf:Int
    var nome:String
    var email:String

    init(_ cpf:Int, _ nome:String, _ email:String) {
        self.cpf = cpf
        self.nome = nome
        self.email = email
    }

    //Não é explicitado se o usuário pode ou não mudar o email ou o nome. Eu julgo essas funções necessárias, 
    // mesmo que seja o nome legal (nomes legais também mudam)
    func setName(_ nome:String) {
        self.nome = nome
    }
    func setEmail(_ email:String) {
        self.email = email
    }

    // Cada subclass tem um override dessa função para imprimir os atributos adicionais
    func printUserData() {
        print("""
        CPF: \(self.cpf)
        Nome: \(self.nome)
        E-mail: \(self.email)
        """)
    }
}

class Aluno:User {
    let matricula:Int
    var plano:Plano
    var nivel:Nivel

    init(_ cpf:Int, _ nome:String, _ email:String, _ matricula:Int, _ plano:Plano, _ nivel:Nivel) {
        self.matricula = matricula
        self.plano = plano
        self.nivel = nivel
        super.init(cpf, nome, email)
    }

    func setNivel(_ nivel:Nivel) {
        self.nivel = nivel
    }

    func setPlano(_ plano:Plano) {
        self.plano = plano
    }  

    override func printUserData() {
        print("""
        CPF: \(self.cpf)
        Nome: \(self.nome)
        E-mail: \(self.email)
        Matricula: \(self.matricula)
        Plano: \(self.plano)
        """)
    }  
}

class Trainers:User {
    let id:Int
    // Eu acho que faz mais sentido um sistema onde cada trainer pode ter mais que uma especialidade
    var especialidades = Set<Categorias>()
    var senioridade:Senioridade

    init(_ cpf:Int, _ nome:String, _ email:String, _ id:Int, _ especialidade:Categorias, _ senioridade:Senioridade) {
        self.id = id
        self.especialidades.insert(especialidade)
        self.senioridade = senioridade
        super.init(cpf, nome, email)
    }

    func addEspecialidade(_ especialidade:Categorias) {
        self.especialidades.insert(especialidade)
    }
    func removeEspecialidade(_ especialidade:Categorias) {
        self.especialidades.remove(especialidade)
    }

    func setSenioridade(_ senioridade:Senioridade) {
        self.senioridade = senioridade
    }
}

class Plano {
    let nome:String
    let mensalidade:Double
    let requerTrainer:Bool
    let limiteAulas:Int
    let duracao:Int 

    static let mensal:Plano = Plano("Plano Mensal", 125.0, false, 10, 1)
    static let trimestral:Plano = Plano("Plano Trimestral", 300.0, true, 45, 3)
    static let anual:Plano = Plano("Plano Anual", 1000, true, 200, 12)

    init(_ nome:String, _ mensalidade:Double, _ requerTrainer:Bool, _ limiteAulas:Int, _ duracao:Int) {
        self.nome = nome
        self.mensalidade = mensalidade
        self.requerTrainer = requerTrainer
        self.limiteAulas = limiteAulas
        self.duracao = duracao
    }
}