rule targets:
    input:
        "data/ghcnd_all.tar.gz",
        "data/ghcnd_all_files.txt",
        "data/ghcnd-inventory.txt",
        "data/ghcnd-stations.txt",
        "data/ghcnd_tidy.tsv",
        "data/ghcnd_canary_regions.tsv"

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
rule summirise_dly_files:
    input:
        bash_script = "code/concatenate_dly.bash",
        r_script = "code/read_split_dly_files.R",
        tarball = "data/ghcnd_all.tar.gz"
    output:
        "data/ghcnd_tidy.tsv"
    shell:
        """
        {input.bash_script}
        """
 
rule aggregate_stations:
    input:
        r_script = "code/merge_lat_lon.R",
        data = "data/ghcnd-stations.txt"
    output:
        "data/ghcnd_canary_regions.tsv"
    shell:
        """
        {input.r_script}
        """
 