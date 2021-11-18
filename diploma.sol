pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ft_diploma is ERC721, Ownable {
  using Strings for uint256;

  string baseURI;
  string public baseExtension = ".json";
  uint256 supply;
  mapping (uint256 => string) logins;
  mapping (string => uint256) loginToId;

  constructor(
    string memory _name,
    string memory _symbol,
    string memory _initBaseURI
  ) ERC721(_name, _symbol) {
    setBaseURI(_initBaseURI);
  }

  // public
  function totalSupply() public view returns(uint256){
      return supply;
  }
  
  function mint(string memory _login, address _to) public onlyOwner {
    logins[supply++] = _login;
    loginToId[_login] = supply - 1;
    _safeMint(_to, supply - 1);
  }

  function tokenURI(uint256 _id) public view onlyOwner override returns(string memory)
  {
    require (_id < supply && _id >= 0, "Error: id does not exist!");
    string memory currentBaseURI = baseURI;
    
    return bytes(currentBaseURI).length > 0 ?
    string(abi.encodePacked(currentBaseURI, logins[_id], baseExtension)) : "none";
  }

  //only owner
  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }

    function getLoginId(string memory _login) public onlyOwner view returns(uint256){
        return loginToId[_login];
    }

    function getBaseURI() public onlyOwner view returns(string memory) {
        return baseURI;
    }
    
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(_msgSender == owner, "Error: Only owner can execute this!");
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_msgSender == owner, "Error: Only owner can execute this!");
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }
    
}
