name="Matthew Gordy"
email="mgordy@usc.edu"
repo_owner="ReadySetDive"
repo_name="csci455-lab-6"


ssh_cfg_dir="../../../.ssh/config"

repo_http_address="https://github.com/$repo_owner/$repo_name.git"
repo_ssh_address="git@github.com:$repo_owner/$repo_name.git"

printf "HTTP REPO ADDRESS: https://github.com/$repo_owner/$repo_name.git\n"
printf " SSH REPO ADDRESS: git@github.com:$repo_owner/$repo_name.git\n\n"



add_ssh_key() {
    KEY_FILE="$PWD/$1"   # Get the full path to the key file in the current directory

    # Check if the file exists
    if [ ! -f "$KEY_FILE" ]; then
        echo "Key file $KEY_FILE does not exist."
        return 1
    fi

    # Remove any existing configuration for "github.com" from .ssh/config
    sed -i.bak '/Host github.com/,/IdentitiesOnly yes/d' $ssh_cfg_dir

    # Add the SSH key to $ssh_cfg_dir if not already present
    if grep -q "$KEY_FILE" $ssh_cfg_dir; then
        echo "Key file $KEY_FILE already exists in $ssh_cfg_dir."
    else
        echo -e "\nHost github.com" >> $ssh_cfg_dir
        echo "    HostName github.com" >> $ssh_cfg_dir
#        echo "    User git" >> $ssh_cfg_dir
        echo "    IdentityFile $KEY_FILE" >> $ssh_cfg_dir
#        echo "    IdentitiesOnly yes" >> $ssh_cfg_dir
        echo "Added $KEY_FILE to {$ssh_cfg_dir}"
    fi
}

fix_ssh_cfg () {
    chmod 600 $ssh_cfg_dir
    chmod 700 $ssh_cfg_dir
}

clean_all () {
rm -rf .git*
rm -rf .auth*
}

config_local_git () {
    git init
    git remote add origin $repo_ssh_address
    git config user.name $name
    git config user.email $email
    git add .
    git commit -m "initial commit"
    git branch -m master main
    touch .gitignore
    echo ".voc/*" >> .gitignore
    echo "*auth*" >> .gitignore
    echo "*.vscode*" >> .gitignore
}

ssh_setup () {
    mkdir .auth
    ssh-keygen -t ed25519 -C "deploy-key" -f ./.auth/deploy_key -N ""
    touch $ssh_cfg_dir
    add_ssh_key .auth/deploy_key
}

initp () {
   git push -u origin main
}

fix_ssh_cfg
clean_all
config_local_git
ssh_setup


printf"\n\n"
printf "MAKE KEY AT THE FOLLOWING:    https://github.com/$repo_owner/$repo_name/settings/keys/new\n"
printf "KEY VALUE:                    "
cat .auth/deploy_key.pub

printf "ADD SUBMODULE WITH:           git submodule add $repo_http_address {ENTER_LOCAL_DIR HERE}"

printf "\nPRESS ENTER TO FINISH"
read ans
printf "\n\n"