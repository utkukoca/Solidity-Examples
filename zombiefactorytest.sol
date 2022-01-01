pragma  solidity  ^0.8.4;

import "./ownable.sol";

contract ZombieFactory is Ownable{
    event NewZombie(uint zombieId, string name, uint dna);
    
    uint dnaDigits=16; //zombilerimizin dnası 16 haneli bir sayıyla belirlenecek.
    
    uint dnaModule=10**dnaDigits; //16 haneli olduğuna emin olmak ve daha sonra bir tamsayıyı 16 basamağa kısaltmak için % modül operatörünü kullanabiliriz.
   
   uint cooldownTime = 1 days;
   
    struct Zombie{  //zombilerimizin özelliklerini tutmak için struct yapsını kullanalım ve iki tane özellik ekleyelim.
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount; //zombimizin kazanma oranı.
        uint16 lossCount; //zombimizin kaybetme oranı.
        
        
    }
    
    mapping (uint=>address) public zombieToOwner; //bir zombinin hangi adrestte olduğunu belirlemek için kullanılır.
    mapping (address =>uint) ownerZombieCount; //bir adrestte kaç tane zombi olduğunu belirlemek için kullanılır.
    
    Zombie[] public zombies;
    function createZombie(string memory _name, uint _dna) internal { 
        zombies.push(Zombie(_name, _dna , 1 , uint32(block.timestamp+cooldownTime),0,0));
        uint id = zombies.length - 1; //dizideki ilk öğrenin indeksi 0 olduğundan -1 kullanmalıyız.
        zombieToOwner[id] = msg.sender; //zombinin ıdsi altında kontratla iletişme geçen hesap tutulur.
        ownerZombieCount[msg.sender]++;//bu adresin sahip olduğu zombi miktarını arttıralım.
        
        
        
        emit NewZombie(id, _name, _dna);
    }
    function generateRandomDna(string memory _str) private view returns(uint){
        uint rand =uint (keccak256(abi.encodePacked(_str))); //hash fonskiyonu sayesinde farklı numaralar elde edebilyoruz.
        return rand % dnaModule; //zombilerin dnasını 16 haneli olmasını sağlar.
        
    }
    function createRandomZombie (string memory _name) public {
        require (ownerZombieCount[msg.sender] == 0 ); //sadece hesabında hiç zombi bulunmayan hesaplar oluşturabilir yani her adres = 1 zombi.
        uint randDna = generateRandomDna(_name); //randDna adlı bir uint oluşturalım ve girilen ismi generateRandomDna adlı fonksiyonda çalıştıralım.
        createZombie(_name,randDna); //zombinin adını ve dnasını createZombie fonkisyonunu kullaranak dizinin içine push edelim.
    }
}
