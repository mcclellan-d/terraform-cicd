terraform {
    backend "remote" {
        organization = "isekai"
        
        workspaces {
            name = "mtc-dev-repo"
        }
    }
}