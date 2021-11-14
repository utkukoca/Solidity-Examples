pragma solidity ^0.8.4;

contract COIN_TEST{
    address public minter; //public sayesinde başka kontratlar erişebilir ve minter 160 bitlik smart kontrat adresini saklar.
    mapping (address=>uint) public balances; //hash tableda adreslerin bir değerle eşleştirilmesini sağlar.
    
    event Sent(address from,address to,uint amount);//coin göndermek için alıcı gönderici adresi ve coin miktarı gerekir bu dinleyerek kullanıcıdan bu bilgileri alır.
    
    constructor(){
        minter = msg.sender; //sözleşme ilk başladığında çalışır sadece.
    }
    
    function mint(address receiver,uint amount) public { //yeni adresde oluşturulan coin sayısını yazmanızı ister.
        require(msg.sender==minter);
        balances[receiver] += amount;
    }
    error InsufficientBalance(uint requested, uint available); //hata mesajının neden alındığını bilgilendirir.
    
    function sent(address receiver, uint amount) public {
        if (amount > balances[msg.sender]) //hatanon hangi durumda verileceğini gösterir
             revert InsufficientBalance({
                 requested:amount,
                 available:balances[msg.sender]
             });
        balances[msg.sender] -=amount; // gönderen kişinin hesabından düşer        
        balances[receiver] +=amount; // alıcı kişinin hesabınındaki coin miktarını arttırır 
        emit Sent(msg.sender, receiver, amount);
    }
