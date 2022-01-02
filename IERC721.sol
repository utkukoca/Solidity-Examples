pragma solidity ^0.8.4;

interface IERC721 {
  event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
  event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

  function balanceOf(address owner) external view returns (uint256 balance);
  function ownerOf(uint256 tokenId) external view returns (address owner);
  function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
  function approve(address to, uint256 tokenId) external;
}
