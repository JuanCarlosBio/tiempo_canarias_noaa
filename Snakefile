rule targets:
    input:
        "data/ghcnd_all.tar.gz",
        "data/ghcnd_all_files.txt",
        "data/ghcnd-inventory.txt",
        "data/ghcnd-stations.txt",
        "data/islands_shp/municipios.shp",
        "data/ghcnd_tidy.tsv",
        "data/ghcnd_canary_regions_years.tsv",
        "figures/precipitaciones_canarias.png",
        "index.html"

rule get_all_archives:
    input:
        script = "code/get_ghcnd_data.bash"
    output:
        "data/ghcnd_all.tar.gz"
    params:
        "ghcnd_all.tar.gz"
    conda:
        "code/envs/ambiente.yml"
    shell:
        """
        bash {input.script} {params}
        """

rule get_all_file_names:
    input:
        script = "code/get_ghcnd_all_files.bash",
        archives = "data/ghcnd_all.tar.gz"
    output:
        "data/ghcnd_all_files.txt"
    conda:
        "code/envs/ambiente.yml"
    shell:
        """
        bash {input.script}
        """

rule get_inventory:
    input:
        script = "code/get_ghcnd_data.bash",
    output:
        "data/ghcnd-inventory.txt"
    params:
        "ghcnd-inventory.txt"
    conda:
        "code/envs/ambiente.yml"
    shell:
        """
        bash {input.script} {params}
        """
    
rule get_stations:
    input:
        script = "code/get_ghcnd_data.bash",
    output:
        "data/ghcnd-stations.txt"
    params:
        "ghcnd-stations.txt"
    conda:
        "code/envs/ambiente.yml"
    shell:
        """
        {input.script} {params}
        """
rule get_shp_canary_islands:
    input:
        bash_script = "code/canary_islands_idecanarias.bash",
    output:
        "data/islands_shp/municipios.shp"
    conda:
        "code/envs/ambiente.yml"
    shell:
        """
        bash {input.bash_script}
        """
 
rule summirise_dly_files:
    input:
        bash_script = "code/concatenate_dly.bash",
        r_script = "code/read_split_dly_files.R",
        tarball = "data/ghcnd_all.tar.gz"
    output:
        "data/ghcnd_tidy.tsv"
    conda:
        "code/envs/ambiente.yml"
    shell:
        """
        bash {input.bash_script}
        """
 
rule get_canary_regions_years:
    input:
        r_script = "code/merge_lat_lon.R",
        data = "data/ghcnd-inventory.txt"
    output:
        "data/ghcnd_canary_regions_years.tsv"
    conda:
        "code/envs/ambiente.yml"
    shell:
        """
        Rscript {input.r_script}
        """

rule plot_drought_canary_region:
    input:
        r_script = "code/plot_drought_canary_regions.R",
        prcp_data = "data/ghcnd_tidy.tsv",
        station_data = "data/ghcnd_canary_regions_years.tsv",
        muni = "data/islands_shp/municipios.shp"
    output:
        "figures/precipitaciones_canarias.png"
    conda:
        "code/envs/ambiente.yml"
    shell:
        """
        Rscript {input.r_script}
        """

rule index_html:
    input:
        rmd = "index.Rmd",
        png = "figures/precipitaciones_canarias.png"
    output:
        "index.html"
    conda:
        "code/envs/ambiente.yml"
    shell:
        """
        R -e "library(rmarkdown); render('{input.rmd}')"
        """
     
