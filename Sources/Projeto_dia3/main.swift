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

enum Equipamentos:String {
    case esteira = "Esteiras", bicicleta = "Bicicletas", isoladores = "Maquina de Musculação", bancoAbdo = "Banco Abdominal"
}

class manager {
    var users:[Int:User] = [:]
    // Usando um sets sicronizado com o dicionário para deixar a busca por valores repetidos mais eficiente.
    private var userEmails = Set<String>()

    var aparelhos:[Int:Equipamento] = [:]
    var aulas:[Int:Aula] = [:]

    // Esses valores são usados para poder criar IDs dinamicamente em ordem crescente.
    var maiorAparelhoID:Int
    var maiorAulaID:Int

    func getUser(_ cpf:Int) -> User? {
        guard let user = users[cpf] else {
            print("ERRO. Esse usuário não existe.")
            return nil
        }
        return user
    }
    func registrarAluno(_ cpf:Int, _ nome:String, _ email:String, _ matricula:Int, _ plano:Plano, _ nivel:Nivel) -> Aluno? {
        if userEmails.contains(email) {
            print("Esse E-mail já está cadastrado.")
            return nil
        }
        else if users[cpf] != nil {
            print("Esse CPF já está cadastrado.")
            return nil
        }

        let newAluno = Aluno(cpf, nome, email, plano, nivel)
        users[cpf] = newAluno
        userEmails.insert(email)

        return newAluno
    }
    func registrarTrainer(_ cpf:Int, _ nome:String, _ email:String, _ especialidade:Categorias, _ senioridade:Senioridade) -> Trainers? {
        if userEmails.contains(email) {
            print("Esse E-mail já está cadastrado.")
            return nil
        }
        else if users[cpf] != nil {
            print("Esse CPF já está cadastrado.")
            return nil
        }

        let newTrainer = Trainers(cpf, nome, email, especialidade, senioridade)
        users[cpf] = newTrainer
        userEmails.insert(email)

        return newTrainer
    }
    func removerUser(_ cpf:Int) {
        if users[cpf] != nil {
            guard let email = users[cpf]?.email else {
                print("ERRO. Usuário registrado não tem e-mail.")
            }
            userEmails.remove(email)
            users[cpf] = nil
        }
        else {
            print("Esse usuário não existe.")
        }
    }

    func getEquipamento(_ id:Int) -> Equipamento? {
        guard let equipamento = aparelhos[id] else {
            print("ERRO. Esse aparelho não existe.")
            return nil
        }
        return equipamento
    }
    func registrarEquipamento(_ tipo:Equipamentos, _ estadoFuncionamento:Bool) -> Equipamento {
        let novoEquipamento = Equipamento(maiorAparelhoID + 1, tipo, estadoFuncionamento)
        maiorAparelhoID += 1
        aparelhos[maiorAparelhoID] = novoEquipamento
        return novoEquipamento
    }
    func removerEquipamento(_ id:Int) {
        if aparelhos[id] != nil {
            aparelhos[id] = nil
        }
        else {
            print("Nenhum aparelho com esse ID registrado.")
        }
    }
    func manutencaoLote(_ data:String, _ lote:Equipamentos) -> [Int] {
        // Essa função corre manutenção em todas as maquinas de um tipo (ex: todas as esteiras) e retorna uma lista de ids das maquinas defeituosas.
        var maquinasQuebradas:[Int]
        let maquinasLote = aparelhos.filter{$0.value.tipo == lote}

        for i in maquinasLote {
            if !i.value.checarEstado() {
                maquinasQuebradas.append(i.key)
            }
        }
        return maquinasQuebradas
    }

    func getAula(_ id:Int) -> Aula? {
        guard let aula = aulas[id] else {
            print("ERRO. Essa aula não existe.")
            return nil
        }
        return aula
    }
    func registrarAulaColetiva(_ nome:String, _ instrutor:Trainers, _ categoria:Categorias, _ descricao:String, _ capacidade:Int) -> AulaColetiva {
        let novaAula = AulaColetiva(maiorAulaID + 1, nome, instrutor, categoria, descricao, capacidade)
        maiorAulaID += 1
        aulas[maiorAulaID] = novaAula
        return novaAula
    }
    func registrarAulaPessoal(_ nome:String, _ instrutor:Trainers, _ categoria:Categorias, _ descricao:String, _ aluno:Aluno) -> aulaPersonal? {
        // Checa se o aluno tem permissão de agendar um personal trainer e o professor tem a especialização necessária para a aula
        if aluno.plano.requerTrainer && instrutor.especialidades.contains(categoria) {
            let novaAula = aulaPersonal(maiorAulaID+1, nome, instrutor, categoria, descricao, aluno)
            maiorAulaID += 1
            aulas[maiorAparelhoID] = novaAula
            return novaAula
        }
    }
    func removerAula(_ id:Int) {
        if aulas[id] != nil {
            aulas[id] = nil
        }
        else {
            print("Nenhuma aula com esse ID registrada.")
        }
    }

    init() {
        self.maiorAparelhoID = 0
        self.maiorAulaID = 0
    }
}

class User:Hashable, Equatable {
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

    // Essas funções são necessárias para criar um set a partir dessa classe. Ela efetivamente diz qual atributo deve ser usado de chave primaria.
    func hash(into hasher: inout Hasher) {
        hasher.combine(cpf)
    }
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.cpf == rhs.cpf
    }
}

class Aluno:User {
    var plano:Plano
    var nivel:Nivel
    //Essa variável guarda a quantidade de aulas em que o usuário está ativamente inscrito. Pode ser comparada com Aluno.plano.limiteAulas
    var aulasColetivas:Int

    init(_ cpf:Int, _ nome:String, _ email:String, _ plano:Plano, _ nivel:Nivel) {
        self.plano = plano
        self.nivel = nivel
        self.aulasColetivas = 0
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
        Plano: \(self.plano)
        """)
    }
}

class Trainers:User {
    // Eu acho que faz mais sentido um sistema onde cada trainer pode ter mais que uma especialidade
    var especialidades = Set<Categorias>()
    var senioridade:Senioridade

    init(_ cpf:Int, _ nome:String, _ email:String, _ especialidade:Categorias, _ senioridade:Senioridade) {
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

    override func printUserData() {
        print("""
        CPF: \(self.cpf)
        Nome: \(self.nome)
        E-mail: \(self.email)
        Especialidade(s): \(self.especialidades)
        Senioridade: \(self.senioridade)
        """)
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

protocol Manutencao {
    var id:Int {get}
    var tipo:Equipamentos {get}
    var estadoFuncionamento:Bool {get}
    var historico:[String] {get}

    func agendarManutencao(_ data:String) -> Bool
    func checarEstado() -> Bool
}

class Equipamento:Manutencao {
    // O codigo do equipamento identifica exatamente cada unidade, tipo é meramente a categoria de equipamento (ex: "esteira")
    let id:Int
    var tipo:Equipamentos
    var estadoFuncionamento:Bool
    var historico:[String] = []

    func agendarManutencao(_ data:String) -> Bool {
        if estadoFuncionamento {
            let resultado = "A manutenção dessa maquina foi agendada para \(data)."
            historico.append(resultado)
            print(resultado)
            return true
        }
        else {
            let resultado = "Essa maquina está defeituosa e o ciclo de manutenção comum, agendado para \(data) não pode ser realizado."
            historico.append(resultado)
            print(resultado)
            return false
        }
    }
    func checarEstado() -> Bool {
        if estadoFuncionamento {
            print("Essa maquina está funcionando.")
        }
        else {
            print("Essa maquina não está funcionando.")
        }
        return estadoFuncionamento
    }

    init(_ id:Int, _ tipo:Equipamentos, _ estadoFuncionamento:Bool) {
        self.id = id
        self.tipo = tipo
        self.estadoFuncionamento = estadoFuncionamento
    }
}

protocol Aula {
    var id:Int {get}
    var nome:String {get}
    var instrutor:Trainers {get}
    var categoria:Categorias {get}
    var descricao:String {get}
}

class AulaColetiva:Aula {
    let id:Int
    var nome:String
    var instrutor:Trainers
    var categoria:Categorias
    var descricao:String
    var capacidade:Int
    // A lista de alunos é um set para evitar duplicação e facilitar comparações/buscas
    var alunos = Set<Aluno>()

    init(_ id:Int, _ nome:String, _ instrutor:Trainers, _ categoria:Categorias, _ descricao:String, _ capacidade:Int) {
        self.id = id
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.capacidade = capacidade
    }

    func inscreverAula(_ aluno:Aluno) {
        // Cada if está separado para permitir a impressão de mensagens de erro mais precisas. 
        // O enunciado só pede duas condições de entrada, mas já existia uma variável que limitava a quantidade 
        // de aulas coletivas que um usuário pode ter de acordo com o plano.
        if (!alunos.contains(aluno)) {
            if (alunos.count < capacidade) {
                if (aluno.aulasColetivas < aluno.plano.limiteAulas) {
                    self.alunos.insert(aluno)
                    aluno.aulasColetivas += 1
                }
                else {
                    print("Seu plano não permite mais aulas coletivas.")
                }
            }
            else {
                print("Essa sala já está cheia.")
            }
        }
        else {
            print("Você já está nessa sala.")
        }
    }

    func sairAula(_ aluno:Aluno) {
        if (alunos.contains(aluno)) {
            alunos.remove(aluno)
        }
        else {
            print("Você não está nessa aula.")
        }
    }
}

class aulaPersonal:Aula {
    let id:Int
    var nome:String
    var instrutor:Trainers
    var categoria:Categorias
    var descricao:String
    var aluno:Aluno

    init(_ id:Int, _ nome:String, _ instrutor:Trainers, _ categoria:Categorias, _ descricao:String, _ aluno:Aluno) {
        self.id = id
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.aluno = aluno
    }
}