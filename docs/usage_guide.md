# Usage guide

## Initial Requirements

- **Rust**: The latest version of Rust (1.60):
  [https://www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install)

- For Mac users, we recommend to have installed **Homebrew**: [https://brew.sh/](https://brew.sh/)

## One-time installation

```shell
git clone https://github.com/dabreegster/spc/
cd spc
# The next command will take a few minutes the first time you do it, to build external dependencies
cargo build --release
```

If you get some errors during the compilation process, take a look at
[Troubleshooting](#Troubleshooting) section below.

## Generating output for a study area

```
cargo run --release -- config/west_yorkshire_small.csv
```

This will download some large files the first time. You'll wind up with
`data/output/west_yorkshire_small.pb` as output, as well as lots of
intermediate files in `data/raw_data/`. The next time you run this command
(even on a different study area), it should go much faster.

## Adding a new study area

A study area requires a list of MSOAs to include. Create a new file `config/your_region.csv` with this list, following the format of the other files in there. (The first line must set the column name as `"MSOA11CD"`.)

You can use the `scripts/select_msoas.py` script to generate this list based on an ONS geography code. The script looks for every MSOA where the `CTY20NM` is Liverpool. Refer to `data/raw_data/referencedata/lookUp.csv` for all geographies.

After you write a new file, you simply run the pipeline with that as input:

```
cargo run --release -- config/your_region.csv
```

## Docker

If you're having trouble building, you can run in Docker. Assuming you have Docker setup:

```shell
git clone https://github.com/dabreegster/spc/
cd spc
# Build the Docker image initially. Once we publish to Docker Hub, this step
# won't be necessary.
docker build -t spc .
# Run SPC in Docker
docker run --mount type=bind,source="$(pwd)"/data,target=/spc/data -t spc /spc/target/release/spc config/west_yorkshire_small.csv
```

This will make the `data` directory in your directory available to the Docker image, where it'll download the large input files and produce the final output.

## Troubleshooting

Please [open an issue](https://github.com/dabreegster/spc/issues) if you have any trouble!

### Building proj

**Symptom**: When you run `cargo build --release`, you get an error like:

```shell
 error: failed to run custom build command for 'proj-sys v0.18.4'
```

**Cause**: The Rust code depends on [proj](https://proj.org) to transform coordinates. You may need to install additional dependencies to build it.

**Suggested Solution**

On Ubuntu, run:

```shell
apt-get install cmake sqlite3 libclang-dev
```

On Mac, run:

```shell
brew install pkg-config cmake proj
```

### Downloading

If you have trouble downloading any of the large files, you can download them manually. The logs will contain a line such as `Downloading https://ramp0storage.blob.core.windows.net/nationaldata/QUANT_RAMP_spc.tar.gz to data/raw_data/nationaldata/QUANT_RAMP_spc.tar.gz`. This tells you the URL to retrieve, and where to put the output file. Note that SPC won't attempt to download files if they already exist, so if you wind up with a partially downloaded file, you have to manually remove it.
