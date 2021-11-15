pragma solidity ^0.8.4;

interface IERC20Test {
    
    function totalSupply() external view returns (uint256); //token miktarını döndürür.
    
    function balanceOf(address account) external view returns (uint256); //hesabın sahip olduğu token miktarı.
    
    function transfer(address recipient,uint256 amount)external returns (bool); //alıcı adresi ve gönderilecek token miktarı.
    
    function allowance(address owner, address spender) external view returns (uint256); //harcayanın kalan token sayısını ve transfrom aracılıyla sahip adına harcama yapılmasına izin verir.

    function approve(address spender, uint256 amount) external returns (bool);
    
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool); //göndereci adresintoken miktarı allowance mekanizması sayesinde düşer.
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);


}
