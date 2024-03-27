rule targets:
    input:
        "data/ghcnd_all.tar.gz",
        "data/ghcnd_all_files.txt",
        "data/ghcnd-inventory.txt",
        "data/ghcnd-stations.txt"

rule get_all_archives:
    input:
        script = "code/get_ghcnd_data.bash"
    output:
        "data/ghcnd_all.tar.gz"
    params:
        "ghcnd_all.tar.gz"
    shell:
        """
        {input.script} {params}
        """

rule get_all_file_names:
    input:
        script = "code/get_ghcnd_all_files.bash",
        archives = "data/ghcnd_all.tar.gz"
    output:
        "data/ghcnd_all_files.txt"
    shell:
        """
        {input.script}
        """

rule get_inventory:
    input:
        script = "code/get_ghcnd_data.bash",
    output:
        "data/ghcnd-inventory.txt"
    params:
        "ghcnd-inventory.txt"
    shell:
        """
        {input.script} {params}
        """
    
rule get_stations:
    input:
        script = "code/get_ghcnd_data.bash",
    output:
        "data/ghcnd-stations.txt"
    params:
        "ghcnd-stations.txt"
    shell:
        """
        {input.script} {params}
        """
 