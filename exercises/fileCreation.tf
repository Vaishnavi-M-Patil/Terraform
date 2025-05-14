# Local Provider:
# 1. Create a directory called "my_first_run"
# 2. Inside the directory create a file called "main.tf" with the following content

resource "local_file" "mario_local_file" {
    content  = "It's a me, Mario!"
    filename = "/tmp/who_is_it.txt"
}

# 3. Run `terraform init`.
# 4. Run `terraform plan`.
# 5. Finally, run 'terraform apply' and verify the file was created
