name = "nep-interview-sftp"
users = {
  user1 = {
    Name          = "user1"
    HomeDirectory = "/nep-interview-user1-bucket/"
    PublicKey     = "ssh-rsa YOUR_SSH_PUBLIC_KEY"
    AllowFrom     = [
        "8.8.8.8"
    ]
    Tags = {
      Name          = "Test user1"
      Organisation  = "NEP"
    }
  }
  user2 = {
    Name           = "user2"
    HomeDirectory  = "/nep-interview-shared-bucket/"
  }
  user3 = {
    Name           = "user3"
    HomeDirectory  = "/nep-interview-shared-bucket/"
    ReadOnly       = true
  }
}
