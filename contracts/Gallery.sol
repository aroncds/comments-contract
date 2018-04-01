pragma solidity ^0.4.18;

import "./Store.sol";

contract Gallery is Store {

    struct Picture {
        address sender;
        string referenceImage;
        string description;
        uint createdAt;
        uint hearts;
    }

    struct Comment {
        address sender;
        string message;
        uint createdAt;
    }

    event OnCreatePicture(string reference, string message);
    event OnCreateComment(address sender, string reference, string message, uint createdAt);

    Picture[] public pictures;
    mapping(address => Picture[]) private pictureByAddress;
    mapping(bytes32 => Picture) private pictureByReference;
    mapping(bytes32 => Comment[]) private comments;

    function Gallery(address _token) public {
        owner = msg.sender;
        if (_token != address(0)){
            token = HeartToken(_token);
        }
    }

    function sendHeartToPicture(string reference, uint amount) public {
        require(token.balanceOf(msg.sender) >= amount);
        Picture storage pic = pictureByReference[keccak256(reference)];
        token.transferFrom(msg.sender, pic.sender, amount);
        pic.hearts += amount;
    }

    function create(string reference, string description) public {
        Picture memory pic = Picture({
            sender: msg.sender,
            referenceImage: reference,
            description: description,
            createdAt: now,
            hearts: 0
        });
    
        pictures.push(pic);
        pictureByReference[keccak256(reference)] = pic;
        pictureByAddress[msg.sender].push(pic);

        OnCreatePicture(reference, description);
    }
    
    function createComment(string reference, string message) public {
        Comment memory comment = Comment({
            createdAt: now,
            sender: msg.sender,
            message: message
        });

        comments[keccak256(reference)].push(comment);
        
        OnCreateComment(msg.sender, reference, message, now);
    }

    function getParsePicture(Picture pic) private view returns(address, string, string, uint, uint, uint) {
        uint commentCount = comments[keccak256(pic.referenceImage)].length;
        return (
            pic.sender,
            pic.referenceImage,
            pic.description,
            pic.createdAt,
            pic.hearts,
            commentCount);
    }

    function getParseComment(Comment comment) private pure returns(address, string, uint) {
        return (
            comment.sender,
            comment.message,
            comment.createdAt);
    }
    
    function getPhotoByReference(string reference) public view returns(address, string, string, uint, uint, uint) {
        return getParsePicture(pictureByReference[keccak256(reference)]);
    }

    function getPhotoByIndex(uint index) public view returns(address, string, string, uint, uint, uint) {
        return getParsePicture(pictures[index]);
    }

    function getMyPhotoByIndex(uint index) public view returns(address, string, string, uint, uint, uint) {
        return getParsePicture(pictureByAddress[msg.sender][index]);
    }

    function getCommentByIndex(string reference, uint index) public view returns(address, string, uint) {
        return getParseComment(comments[keccak256(reference)][index]);
    }

    function getMyPhotoCount() public view returns(uint) {
        return pictureByAddress[msg.sender].length;
    }

    function getCommentCount(string reference) public view returns(uint) {
        return comments[keccak256(reference)].length;
    }

    function getCount() public view returns(uint) {
        return pictures.length;
    }
}