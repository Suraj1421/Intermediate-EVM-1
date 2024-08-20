// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract BloggingApp {
    enum RegistrationStatus { Unregistered, Registered }
    enum BlogStatus { NonExistent, Existing }

    struct Blog {
        string title;
        string body;
        BlogStatus exists;
    }

    struct User {
        string username;
        RegistrationStatus status;
    }

    // User Functionality

    mapping(address => User) public users;

    function createUserAccount(string memory username, address _addr) public returns (string memory) {
        if (users[_addr].status == RegistrationStatus.Registered)
            revert("Already registered");

        users[_addr] = User(username, RegistrationStatus.Registered);
        return string(abi.encodePacked(username, " successfully registered"));
    }

    // Blogging Functionality

    mapping(address => Blog) public blogs;

    function publishBlogPost(string memory title, string memory body, address _user) public {
        assert(users[_user].status == RegistrationStatus.Registered);
        blogs[_user] = Blog(title, body, BlogStatus.Existing);
    }

    function readBlogPost(address _user) public view returns (Blog memory) {
        if (blogs[_user].exists == BlogStatus.NonExistent)
            revert("Blog doesn't exist");
        return blogs[_user];
    }

    // Admin Functionality

    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function removeBlogPost(address _user, address _adminAddr) public {
        require(admin == _adminAddr, "Unauthorized");
        blogs[_user].exists = BlogStatus.NonExistent;
    }
}