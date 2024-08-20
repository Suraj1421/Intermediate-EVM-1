# Blogging App Contract

## Description

This Solidity contract enhances the blogging application on the Ethereum blockchain. It defines structures for users and blogs, allowing users to register, write blogs, and view specific blogs. The contract includes admin functionalities to delete blogs, ensuring only registered users can write blogs.

## Features
 - User Registration: Users can create accounts with unique usernames.
 - Blogging: Registered users can publish blog posts with titles and bodies.
 - Blog Management: Admins can delete blog posts.
 - Data Access: Users can view existing blog posts.

## Getting Started

### Executing Program

To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at [Remix Ethereum](https://remix.ethereum.org/).

```solidity
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

    /**
     * Creates a user account with a unique username.
     * 
     * @param username The desired username.
     * @param _addr The user's Ethereum address.
     * 
     * @return A success message with the username.
     */
    function createUserAccount(string memory username, address _addr) public returns (string memory) {
        if (users[_addr].status == RegistrationStatus.Registered)
            revert("Already registered");

        users[_addr] = User(username, RegistrationStatus.Registered);
        return string(abi.encodePacked(username, " successfully registered"));
    }

    // Blogging Functionality

    mapping(address => Blog) public blogs;

    /**
     * Publishes a blog post with a title and body.
     * 
     * @param title The blog post title.
     * @param body The blog post body.
     * @param _user The user's Ethereum address.
     */
    function publishBlogPost(string memory title, string memory body, address _user) public {
        assert(users[_user].status == RegistrationStatus.Registered);
        blogs[_user] = Blog(title, body, BlogStatus.Existing);
    }

    /**
     * Retrieves an existing blog post.
     * 
     * @param _user The user's Ethereum address.
     * 
     * @return The blog post with title and body.
     */
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

    /**
     * Deletes a blog post.
     * 
     * @param _user The user's Ethereum address.
     * @param _adminAddr The admin's Ethereum address.
     */
    function removeBlogPost(address _user, address _adminAddr) public {
        require(admin == _adminAddr, "Unauthorized");
        blogs[_user].exists = BlogStatus.NonExistent;
    }
}
```
To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to "0.8.26" (or another compatible version), and then click on the "Compile Token.sol" button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the "Token" contract from the dropdown menu, and then click on the "Deploy" button.

## License
This project is licensed under the MIT License - see the LICENSE.md file for details
