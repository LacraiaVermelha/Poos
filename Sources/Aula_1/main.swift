import Foundation

//Set
var meuSet1: Set<String> = ["A", "B", "C"]
var meuSet2: Set<String> = ["B"]
print(meuSet1.contains("A"))
print(meuSet1.intersection(meuSet2))
print(meuSet1.union(meuSet2))

//Tuple
var tupla = (1, "A")
print(tupla.0)
switch tupla {
    case (let valor, let letra) where (valor == 1 && letra == "A"):
        print("OK")
    default:
        print("not ok")
}

//Dictionary
var estoque: [String: Int] = ["macas": 3, "bananas": 12, "abacaxi": 1]
estoque["ameixas"] = 4
estoque["macas"] = 3 + estoque["macas", default: 0]
estoque.removeValue(forKey: ("macas"))
print(estoque)