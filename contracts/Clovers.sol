pragma solidity ^0.4.17;

/**
 * Digital Asset Registry for the Non Fungible Token Clover
 * with upgradeable contract reference for returning metadata.
 */

import "zeppelin-solidity/contracts/token/ERC20.sol";
import "zeppelin-solidity/contracts/token/ERC721Token.sol";
import "zeppelin-solidity/contracts/ownership/isOwnable.sol";
import "CloversMetadata.sol";

contract Clovers is ERC721Token, isOwnable {

    uint256 Symmetricals;
    uint256 RotSym;
    uint256 Y0Sym;
    uint256 X0Sym;
    uint256 XYSym;
    uint256 XnYSym;
    address cloversMetadata;
    address cloversController;

    mapping (uint256 => Clover) public clovers;
    struct Clover {
        bytes1 symmetries;
        bytes15 cloverMoves;
        uint256 blockMinted;
        uint256 rewards;
    }
    mapping (bytes32 => address) public commits;
    mapping (bytes32 => uint256) public stakes;

    modifier onlyOwnerOrController() {
        require(
            msg.sender == cloversController ||
            msg.sender == owner
        );
        _;
    }

    function Clovers () public {}

    function tokenMetadata(uint _tokenId) public view returns (string _infoUrl) {
        return CloversMetadata(cloversMetadata).tokenMetadata(_tokenId);
    }
    function getStake(bytes32 movesHash) public view returns (uint256) {
        return stakes[movesHash];
    }
    function getCommit(bytes32 movesHash) public view returns (address) {
        return commits[movesHash];
    }
    function getBlockMinted(uint256 _tokenId) public view returns (uint256) {
        return clovers[_tokenId].blockMinted;
    }
    function getCloverMoves(uint256 _tokenId) public view returns (bytes15) {
        return clovers[_tokenId].cloverMoves;
    }
    function getReward(uint256 _tokenId) public view returns (uint256) {
        return clovers[_tokenId].rewards;
    }
    function getSymmetries(uint256 _tokenId) public view returns (bytes1) {
        return clovers[_tokenId].symmetries;
    }
    function getAllSymmetries() public view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
        return (
            Symmetricals,
            RotSym,
            Y0Sym,
            X0Sym,
            XYSym,
            XnYSym
        );
    }

/* ---------------------------------------------------------------------------------------------------------------------- */

    function moveEth(address _to, uint256 amount) public onlyOwnerOrController returns (bool) {
        require(amount <= this.balance);
        _to.transfer(amount);
        return true;
    }
    function moveToken(uint256 amount, address _to, address token) public onlyOwnerOrController returns (bool) {
        require(amount <= ERC20(token).balanceOf(this));
        return ERC20(token).transfer(_to, amount);
    }
    function approveToken(uint256 amount, address _to, address token) public onlyOwnerOrController returns (bool) {
        return ERC20(token).approve(_to, amount);
    }

    function setStake(bytes32 movesHash, uint256 stake) public onlyOwnerOrController {
        stakes[movesHash] = stake;
    }
    function setCommit(bytes32 movesHash, address commiter) public onlyOwnerOrController {
        require(commiter != 0);
        commits[movesHash] = commiter;
    }
    function setBlockMinted(uint256 _tokenId, uint256 value) public onlyOwnerOrController {
        clovers[_tokenId].blockMinted = value;
    }
    function setCloverMoves(uint256 _tokenId, bytes15 moves) public onlyOwnerOrController {
        clovers[_tokenId].cloverMoves = moves;
    }
    function setReward(uint256 _tokenId, uint256 _amount) public onlyOwnerOrController {
        clovers[_tokenId].rewards = _amount;
    }
    function setSymetries(uint256 _tokenId, bytes1 _symmetries) public onlyOwnerOrController {
        clovers[_tokenId].symmetries = _symmetries;
    }

    function updateCloversControllerAddress(address _cloversController) public onlyOwner {
        require(_cloversController != 0);
        cloversController = _cloversController;
    }
    function updateCloversMetadataAddress(address _cloversMetadata) public onlyOwner {
        require(_cloversMetadata != 0);
        cloversMetadata = _cloversMetadata;
    }

    function mint (address _to, uint256 _tokenId) public onlyOwnerOrController returns (bool) {
        _mint(_to, _tokenId);
    }
    function burn (uint256 _tokenId) public onlyOwnerOrController returns (bool) {
        blockMinted[_tokenId] = 0;
        cloverMoves[_tokenId] = 0;
        _burn(_tokenId);
    }

}
