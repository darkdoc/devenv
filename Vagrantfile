Vagrant.configure('2') do |config|
    config.vm.define "ubuntu_22" do |ubuntu|
        ubuntu.vm.box = 'generic/ubuntu2204'
        ubuntu.vm.hostname = "ubuntu"
        ubuntu.vm.synced_folder ".", "/vagrant", disabled: true 
        ubuntu.vm.provider "virtualbox" do |vb|
            vb.name = "ubuntu22"
            vb.memory = "2048"
        end
        ubuntu.vm.provider "hyperv" do |h|
            h.vmname = "ubuntu22"
            h.memory = "2028"
        end
    end

    config.vm.define "ubuntu_23" do |ubuntu|
        ubuntu.vm.box = 'generic/ubuntu2310'
        ubuntu.vm.hostname = "ubuntu"
        ubuntu.vm.synced_folder ".", "/vagrant", disabled: true 
        ubuntu.vm.provider "virtualbox" do |vb|
            vb.name = "ubuntu23"
            vb.memory = "2048"
        end
        ubuntu.vm.provider "hyperv" do |h|
            h.vmname = "ubuntu23"
            h.memory = "2028"
        end
    end

    config.vm.define "fedora" do |fedora|
        fedora.vm.box = "generic/fedora39"
        fedora.vm.hostname = "fedora" 
        fedora.vm.synced_folder ".", "/vagrant", disabled: true
        fedora.vm.provider "virtualbox" do |vb|
            vb.name = "fedora"
            vb.memory = "2048"
        end
        fedora.vm.provider "hyperv" do |h|
            h.vmname = "fedora"
            h.memory = "2028"
        end
    end 
end
