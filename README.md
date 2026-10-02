# PathFold-Workbench
Independent PathFold derivative with a Qt workbench, CPU inference packaging, provenance-aware trajectory analysis and scientific exports. Linux x86-64 / WSL2.
# PathFold Workbench

**An independent desktop and reproducibility-focused derivative of [Kihara Lab's PathFold](https://github.com/kiharalab/PathFold).**

PathFold Workbench adds a six-stage desktop interface, a separately packaged CPU inference engine, explicit structure and feature provenance, trajectory analysis and comparison, and reusable scientific exports around the original PathFold model. The **0.2.4 Compact CPU distribution** targets **Linux x86-64**, including compatible Ubuntu environments under **Windows Subsystem for Linux 2 (WSL2)**. Windows users run the Linux application through WSLg; this release is **not a native Windows executable**.

The original model, training work, checkpoints and PathScorer originate from **Kihara Lab and the original PathFold contributors**. This derivative is maintained by **Siddharth Singh** under [`SidSin0809/PathFold-Workbench`](https://github.com/SidSin0809/PathFold-Workbench). It is not an official Kihara Lab release and does not imply endorsement by the original authors.

> **Scientific scope:** Workbench retains the original trained architecture and three checkpoint assets, but changes parts of inference execution, geometry handling, random-number scheduling and candidate selection. Identical weights do **not** imply identical trajectories to upstream PathFold. Generated frames are Cα model proposals, not physical-time molecular dynamics, calibrated confidence estimates or evidence of improved biological prediction.


## Contents

1. [Release identity and evidence](#release-identity-and-evidence)
2. [What Workbench adds](#what-workbench-adds)
3. [What is retained from upstream](#what-is-retained-from-upstream)
4. [Download the correct package](#download-the-correct-package)
5. [Requirements and supported scope](#requirements-and-supported-scope)
6. [Install on Windows through WSL2](#install-on-windows-through-wsl2)
7. [Launch an existing installation](#launch-an-existing-installation)
8. [Understand the diagnostic results](#understand-the-diagnostic-results)
9. [Connect the CPU engine to the GUI](#connect-the-cpu-engine-to-the-gui)
10. [First analysis without inference](#first-analysis-without-inference)
11. [First real CPU inference job](#first-real-cpu-inference-job)
12. [Custom inputs and feature provenance](#custom-inputs-and-feature-provenance)
13. [Configuration reference](#configuration-reference)
14. [Interpret results correctly](#interpret-results-correctly)
15. [Projects, run folders and publication exports](#projects-run-folders-and-publication-exports)
16. [Optional tools and AF3 interoperability](#optional-tools-and-af3-interoperability)
17. [Research declarations and paired comparisons](#research-declarations-and-paired-comparisons)
18. [Reproducibility and validation boundaries](#reproducibility-and-validation-boundaries)
19. [Known limitations and troubleshooting](#known-limitations-and-troubleshooting)
20. [Source installation and development](#source-installation-and-development)
21. [Repository and release organization](#repository-and-release-organization)
22. [Contributing and reporting issues](#contributing-and-reporting-issues)
23. [License, attribution and citation](#license-attribution-and-citation)

## Release identity and evidence

| Item | Identity or scope |
|---|---|
| Application | PathFold Workbench 0.2.4 |
| Recommended downstream release tag | `workbench-v0.2.4` |
| Binary target | Linux x86-64; CPU edition |
| Upstream repository | `kiharalab/PathFold` |
| Pinned upstream comparison commit | `35cd859bae0530185c275ffa8b62b063ea1c3347` |
| Compact CPU archive | `PathFold-Complete-0.2.4-Linux-x86_64-Compact-CPU.zip` |
| Compact archive size observed in the maintainer's transcript | `901M` from Linux `ls -lh`; approximately 901 MiB, not an exact byte count |
| Unpacked compact distribution before CPU setup | `906M` from Linux `du -sh`; disk usage, not a RAM requirement |
| Compact archive SHA-256 reported and checked on the Windows copy | `c38e8ef408e1088471fcae982f8dcca4fd565be07e26863c41d8f5933e12073d` |


The software behavior described below is grounded in the supplied 0.2.4 change register and user guide. The compact-package checks are grounded in the maintainer's separate WSL terminal transcript. Recorded release-host experiments and local operator diagnostics have different scopes.

## What Workbench adds

### Desktop workflow

The native PySide6 interface uses six pages:

| Page | Purpose |
|---|---|
| **Prepare** | Select a work mode, order input structures, keep the reference separate, preview coordinates and validate inputs. |
| **Configure** | Set analysis parameters or inference settings; inspect effective configuration. |
| **Run** | Start a separate worker, inspect progress and logs, and request supported pause, cancellation or recovery actions. |
| **Explore** | Inspect completed structures, metrics, contact matrices, residue identities and figure recipes. |
| **Compare** | Compare explicitly mapped trajectories and optionally analyze research declarations or paired measurements. |
| **Export** | Publish and verify reusable result bundles, arrays, tables and figures. |

Changing pages or configuring a draft does not execute a job. Explore and Export need an actual completed snapshot. Inference runs in a separate process so the GUI and the heavy inference runtime do not share the same dependency environment.

### Inference engineering

Workbench introduces explicit model and feature admission, CPU FP32 execution, separately identified candidate seeds, bounded microbatch recovery, coarse geometry screening, candidate audits and committed recovery states. Raw proposals and rejection reasons are retained. Input, model, feature and effective-configuration identities are recorded separately.

The active engine is not simply a graphical wrapper around the original script: numerical corrections and orchestration changes can alter selected structures. Experimental beam search, backtracking and adaptive extra proposals are explicitly separated from ordinary settings and have no established predictive-improvement claim.

### Structure handling, analysis and export

Structures preserve residue identities, chain information, observed-atom availability, missing-coordinate masks and scientific roles. Supported records distinguish initial conditions, generated structures, references, imported samples and reconstructed derivatives.

Analysis includes contact-set measurements, reference and adjacent-frame Cα RMSD, radius of gyration, contact persistence, eligible domain descriptors, aligned-coordinate PCA and optional descriptive Isomap. Trajectory comparison uses an explicit global affine-gap objective rather than silently applying historical loader order or score semantics.

Exports can include exact NPZ or pinned-v2 Zarr arrays, typed CSV tables, figure source data and recipes, SVG/PDF/PNG/TIFF figures, permitted structures, manifests and checksums. Replotting uses saved results rather than requiring the original absolute input paths.

### Packaging

The desktop runtime carries Qt and analysis components; the CPU engine carries PyTorch and inference components. The compact distribution keeps the CPU edition compressed until setup, avoiding a second expanded CPU tree inside the download. Optional PULCHRA, DSSP and OpenMM tool archives are separate from ordinary Cα analysis.

## What is retained from upstream

The reviewed source comparison reports **80 original files**, **873 delivered application-tree files**, **793 additions**, **nine edited original paths**, **71 byte-identical original files** and **no deleted original paths**. Those counts describe the reviewed source kit, not a count of new algorithms, not the compact ZIP's file count, and not an invariant after later documentation changes. The build's tracked-source record contains 867 files; six additional preserved checkpoint/configuration assets complete the packaged application tree.

The original neural architecture, diffusion implementations and schedule, registered trained histories, checkpoints and associated configurations are retained. Original example assets and historical instructions are preserved in the source records. In particular, `docs/upstream_README.md` and `docs/upstream_setup.py` retain upstream instructions for historical reference; they are not the recommended Workbench installation procedure.

| Trained history | Model name | Version | Epoch |
|---|---|---|---|
| 1 | `folding_after50_08062024` | `version_0` | `epoch=6.ckpt` |
| 3 | `folding_after3x50_04112025` | `version_1` | `epoch=5.ckpt` |
| 6 | `folding_after6x50_04112025` | `version_2` | `epoch=5.ckpt` |

The nine edited upstream paths are `.gitignore`, `README.md`, `setup.py`, `scripts/run_example_4INW_A.sh`, `pathfold/inference/run_inference.py`, `pathfold/utils/data_io.py`, `pathfold/utils/geo_utils.py`, `pathfold/utils/model_io.py` and `pathscorer/pathscorer.py`.

Notable behavior changes include genuine binary NPY output, explicit Cα representation, a Cartesian-axis Frenet cross-product correction, stricter model loading, evaluation/inference-mode execution, independently scheduled random streams, corrected contact/alignment semantics and structured failure reporting. Original and corrected PathScorer results must not be combined under one method label.

## Download the correct package

Open this repository's **Releases** page and choose the release for Workbench 0.2.4. For the prebuilt application, download:

```text
PathFold-Complete-0.2.4-Linux-x86_64-Compact-CPU.zip
PathFold-Complete-0.2.4-Linux-x86_64-Compact-CPU.zip.sha256
```

GitHub's automatically generated **Source code (zip)** and **Source code (tar.gz)** links are source snapshots. They are **not** the compact prebuilt GUI/CPU package.

The corresponding modified source and build material must be available separately with the release. End users do not need to install the developer kit to run the frozen application, but that separation does not remove the distributor's source and licensing obligations.

### Compact package contents

Before CPU setup, the package has this layout:

```text
PathFold-0.2.4-Linux-x86_64-Compact-CPU/
├── Doctor.sh
├── Doctor-CPU.sh
├── PathFold.sh
├── Setup-CPU.sh
├── Start-Engine.sh
├── Start-PathFold.sh
├── runtime/
│   └── PathFoldWorkbench-0.2.4-x86_64.AppImage
├── packages/
│   └── PathFold-CPU-Edition-0.2.4-Linux-x86_64.tar.gz
└── packs/
    ├── PACKAGE_CONTENTS.json
    ├── START_HERE.md
    └── archives/
        ├── PathFold-DSSP-4.2.2-Linux-x86_64-glibc239.tar.gz
        ├── PathFold-OpenMM-v2-8.3.1-Linux-x86_64.tar.gz
        └── PathFold-PULCHRA-Linux-x86_64-glibc239-23a3e4af.tar.gz
```

CPU setup adds `cpu/PathFold-CPU-Edition-0.2.4-Linux-x86_64/`. That edition includes its engine, registered checkpoints/configurations, bundled 4INW_A inputs and integrity/notice material.

The compact **top level** excludes the older distribution's `docs/`, `examples/`, source-developer-kit ZIP, pre-expanded `cpu/` tree and generated `user-data/`. It also excludes the older `Verify-Package.sh`. It does **not** mean that every nested example, license or help file was removed from the CPU/tool archives. Those archives retain their integrity-bound contents.

**Keep the bundled CPU `.tar.gz` after setup.** The observed launch/diagnostic chain still requires it; removing it can cause `The bundled complete CPU archive is missing.` Keep `Setup-CPU.sh` as well. Do not strip individual files from an integrity-checked runtime or edit its checksum manifest to hide a failure.

## Requirements and supported scope

The binary target is **Linux x86-64**, not ARM64. The recorded release-build host used Ubuntu 24.04 with glibc 2.39 and Qt offscreen. The maintainer's compact-package transcript reports successful extraction, CPU setup and diagnostics on Ubuntu 26.04.1 under WSL2 with glibc 2.43. These observations are not a universal Linux compatibility guarantee.

Windows GUI use requires a working **WSL2/WSLg** configuration. Microsoft's GUI-app documentation specifies Windows 11 or Windows 10 build 19044 or later for this feature. Use a Windows version still covered by the applicable Microsoft support policy; the WSLg feature floor is not a statement about Windows lifecycle support.

The frozen package includes its Python runtimes and application dependencies. A separate Python, Conda environment or global PyTorch installation is not required for the prebuilt route. Shell utilities such as `unzip`, `tar` and `sha256sum` are required for extraction and checks.

Allow at least **10 GB of free working space** as practical installation/testing headroom, plus space for scientific inputs and outputs. This is guidance, not a universal measured minimum. Check the Windows host volume as well as the Linux filesystem: a WSL virtual disk's apparent capacity does not establish free physical space on the host. RAM and runtime depend on protein length, pair features, candidate count and analysis scale; no universal minimum-RAM or throughput claim is made.

GPU acceleration, native Windows binaries, Apple Silicon/ARM64 and macOS/MPS inference are not qualified by this CPU release. An accelerator appearing in a device selector does not establish a compatible installed backend or a numerically qualified model route.

## Install on Windows through WSL2

### 1. Open or install Ubuntu

In **Windows PowerShell**:

```powershell
wsl --list --verbose
```

For an existing distribution named `Ubuntu` showing `VERSION 2`:

```powershell
wsl -d Ubuntu
```

On a new machine without an installed Linux distribution, follow [Microsoft's WSL installation instructions](https://learn.microsoft.com/en-us/windows/wsl/install). The normal installation command, from an administrator PowerShell window, is:

```powershell
wsl --install -d Ubuntu
```

Restart when requested and create a Linux username/password. Password entry displays no characters. Use the exact installed distribution name; a catalog entry named `Ubuntu` does not guarantee a particular Ubuntu release.

### 2. Locate the downloaded ZIP

The following example assumes both download files are stored directly in **`D:\`**:

```text
D:\PathFold-Complete-0.2.4-Linux-x86_64-Compact-CPU.zip
D:\PathFold-Complete-0.2.4-Linux-x86_64-Compact-CPU.zip.sha256
```

Inside **Ubuntu**, Windows `D:` normally appears as `/mnt/d`. A download in another folder needs its actual path. For example, the maintainer's earlier nested location was `/mnt/d/PathFold/PathFold-Complete-Portable/Single-ZIP/`; that is not a required installation directory.

Prepare the extraction utility:

```bash
sudo apt update
sudo apt install -y unzip
```

### 3. Verify and install into a new Linux directory

Run this block in **Ubuntu**, not PowerShell. It deliberately stops on a failed check and refuses to merge into an existing installation:

```bash
(
    set -eu

    ZIP_NAME="PathFold-Complete-0.2.4-Linux-x86_64-Compact-CPU.zip"
    DOWNLOAD_DIR="/mnt/d"
    PF_HOME="$HOME/PathFold"
    PF_ROOT="$PF_HOME/PathFold-0.2.4-Linux-x86_64-Compact-CPU"

    test "$(uname -m)" = "x86_64" || {
        echo "This archive targets Linux x86-64." >&2
        exit 1
    }

    cd "$DOWNLOAD_DIR"
    test -f "$ZIP_NAME"
    test -f "$ZIP_NAME.sha256"
    sha256sum -c "$ZIP_NAME.sha256"
    unzip -tq "$ZIP_NAME"

    if [ -e "$PF_ROOT" ] || [ -L "$PF_ROOT" ]; then
        echo "Installation already exists: $PF_ROOT" >&2
        echo "Use the existing installation or choose a new PF_HOME." >&2
        exit 1
    fi

    mkdir -p "$PF_HOME"
    unzip -q "$DOWNLOAD_DIR/$ZIP_NAME" -d "$PF_HOME"
    cd "$PF_ROOT"

    ./Setup-CPU.sh
    ./Doctor.sh
    ./Doctor-CPU.sh
)
```

Inspect the final diagnostic JSON before starting scientific work. A successful command exit and operator checks are not a replacement for model qualification.

The checksum reported for the specific compact archive tested in the maintainer's transcript is:

```text
c38e8ef408e1088471fcae982f8dcca4fd565be07e26863c41d8f5933e12073d
```

Any repackaging changes the archive bytes and can change this hash. Use the checksum accompanying the exact release asset and compare with the separately published release record. A matching checksum establishes byte equality to that record, not independent publisher authentication.

### 4. Launch

```bash
PF_ROOT="$HOME/PathFold/PathFold-0.2.4-Linux-x86_64-Compact-CPU"
cd "$PF_ROOT" && ./Start-PathFold.sh
```

A visible Workbench window should open through WSLg. The shell may remain attached or return a prompt depending on the launcher. A returned prompt alone is not proof that a window opened. Keep startup output available, verify the actual window and close it normally after use.

### Linux without Windows

On a compatible Linux x86-64 host, use the same verification, extraction and setup sequence with `DOWNLOAD_DIR` set to the actual Linux download folder. Omit PowerShell/WSL commands. A usable local graphical session is required for the GUI. Do not infer qualification for another distribution solely from the CPU architecture.

## Launch an existing installation

For subsequent launches, CPU setup and ZIP extraction are not ordinary prerequisites. In Ubuntu:

```bash
PF_ROOT="$HOME/PathFold/PathFold-0.2.4-Linux-x86_64-Compact-CPU"
cd "$PF_ROOT" && ./Start-PathFold.sh
```

`PF_ROOT` is a convenience shell variable, not an application setting. Define it again in each new terminal. The Windows ZIP location is unrelated to the installed Linux directory.

For suspected runtime damage or after moving an installation:

```bash
PF_ROOT="$HOME/PathFold/PathFold-0.2.4-Linux-x86_64-Compact-CPU"
cd "$PF_ROOT" && ./Doctor.sh && ./Doctor-CPU.sh
```

Do **not** invoke `./Verify-Package.sh` for this compact distribution. Verify its distributed ZIP with `sha256sum`/`unzip`, and use the appropriate diagnostics for installed components. Archive checks do not independently rehash every later-modified installed desktop file.

## Understand the diagnostic results

| Observation | Interpretation |
|---|---|
| `Doctor.sh`: `status: completed`, `frozen: true` | The frozen desktop diagnostic executed. |
| Desktop `torch: null`, `engine_available: false` | Expected for the split analysis-only desktop; does not establish failure of the separate CPU engine. |
| `Doctor-CPU.sh`: `torch: 2.8.0+cpu`, `engine_available: true` | The separate CPU runtime is available. |
| CPU `operator_probe_passed: true` | The listed tensor operators executed in the diagnostic. |
| `multiprocessing_probe.status: passed` | The tested spawned child started and exited correctly. |
| CPU `package_integrity.valid: true` | The declared CPU payload and executable-bit checks passed. The recorded compact test checked 3,674 files. |
| CPU `available_unqualified`, `qualified: false` | Availability is not full-model numerical or scientific qualification. |
| CUDA/XPU unavailable | Expected for a CPU-only runtime unless a separate compatible backend has been installed and deliberately selected. |

The checks do not generate a scientific pathway. They do not establish full-model accuracy, exact cross-hardware reproducibility, live AF3 capability or a working WebGL renderer.

## Connect the CPU engine to the GUI

CPU setup does not by itself demonstrate that the GUI's inference fields point to the installed engine. Print the paths:

```bash
PF_ROOT="$HOME/PathFold/PathFold-0.2.4-Linux-x86_64-Compact-CPU"
CPU_ROOT="$PF_ROOT/cpu/PathFold-CPU-Edition-0.2.4-Linux-x86_64"

printf 'Engine executable: %s\n' "$CPU_ROOT/engine/PathFoldEngine"
printf 'Checkpoint directory: %s\n' "$CPU_ROOT/checkpoints"
```

In **Prepare**, select **Run PathFold**. In **Configure**, paste those actual printed paths into **Optional engine executable** and **Checkpoint directory**. Choose **CPU · FP32** and begin with microbatch **1**.

Select `engine/PathFoldEngine`, not the shell wrapper `Start-Engine.sh`, in the GUI executable field. GUI text fields do not expand `$HOME`, `$PF_ROOT` or `$CPU_ROOT`. Keep the engine's neighboring files intact.

## First analysis without inference

A local analysis does not need the CPU inference engine or AF2 embeddings. Start with the GUI's **Demo** action or your own explicitly ordered structures.

For Demo, choose **Explore existing results**, inspect the filled input order and separate reference, and select **Preview ordered frames** and **Validate inputs**. The documented demonstration uses a contact cutoff of **14 Å**, minimum sequence separation **3**, strict coverage, mapping `{"X":"A"}` and display smoothing **1**. That chain mapping is specific to the example; do not apply it indiscriminately to other proteins.

Proceed to **Run** and click **Start**. Wait for the worker to complete and the snapshot to finish loading. Then inspect frames and metrics in **Explore**, save a `.pfproject`, and create a new verified export bundle in **Export**.

Demo input paths may be inside a temporary AppImage extraction folder. Use Demo to populate the current paths rather than copying a stale `/tmp/appimage_extracted_...` path from a previous session. Historical instructions referring to top-level `examples/result.bundle` describe the larger distribution, not a file promised in the compact top level.

For your own input, preserve order using an explicit list or a valid trajectory manifest. Keep the reference out of the ordered generated/imported frames. Without an explicit reference, first-frame alignment does not create native-contact or reference-RMSD measurements.

## First real CPU inference job

### GUI route

After connecting the engine, the bundled history-one example uses:

| GUI field | Path or setting |
|---|---|
| Initial structure | `CPU_ROOT/examples/4INW_A/initial_frames/4INW_A_frame_0492.pdb` |
| Separate reference | `CPU_ROOT/examples/4INW_A/folded_reference.pdb` |
| AF2 feature bundle | `CPU_ROOT/examples/4INW_A/embeddings/4INW_A.npz` |
| Feature provenance JSON picker | Leave blank for this exact byte-identified example. |
| Chain mapping | `{"X":"A"}` |
| History | `1` |
| Candidate budget | `1` |
| Maximum generated steps | `1` |
| Seed | `25` |
| Device / precision | CPU / FP32 |
| Microbatch | `1` |
| Output | A new, unused run directory. |

Substitute actual absolute paths for `CPU_ROOT` in the GUI. To match the documented small real workload, use the advanced settings:

```json
{
  "threads": 2,
  "max_progress_per_step": 1.0,
  "stop_similarity": 1.0
}
```

Use one thread on a host exposing only one logical processor. Inspect effective settings: the workload still uses **1,000 diffusion indices**, not a shortened denoising process. Validate inputs before Start.

A completed search may report `no_admissible_candidate`; it is not a successful folding prediction. An initial state already meeting the stopping criterion can complete without new proposals. Preserve the termination reason, geometry audit and raw candidates.

### Terminal route

The following creates a new configuration outside the immutable runtime. It does not start inference until the separate final command. Choose another `RUN_ID` for a separate trial.

```bash
PF_ROOT="$HOME/PathFold/PathFold-0.2.4-Linux-x86_64-Compact-CPU"
CPU_ROOT="$PF_ROOT/cpu/PathFold-CPU-Edition-0.2.4-Linux-x86_64"
RUN_ID="4INW_A_seed25_trial01"
RUN_ROOT="$HOME/PathFold-work/runs/$RUN_ID"
CONFIG_PATH="$HOME/PathFold-work/configs/$RUN_ID.json"

(
    set -eu
    test -x "$CPU_ROOT/engine/PathFoldEngine"
    test ! -e "$RUN_ROOT"
    test ! -e "$CONFIG_PATH"
    mkdir -p "$HOME/PathFold-work/configs" "$HOME/PathFold-work/runs"

    cat > "$CONFIG_PATH" <<JSON
{
  "schema_version": "1.0",
  "preset": "corrected_baseline_v1",
  "history": 1,
  "initial_frames": ["$CPU_ROOT/examples/4INW_A/initial_frames/4INW_A_frame_0492.pdb"],
  "reference": "$CPU_ROOT/examples/4INW_A/folded_reference.pdb",
  "features": "$CPU_ROOT/examples/4INW_A/embeddings/4INW_A.npz",
  "checkpoint_root": "$CPU_ROOT/checkpoints",
  "chain_mapping": {"X": "A"},
  "output_dir": "$RUN_ROOT",
  "device": "cpu",
  "precision": "float32",
  "threads": 2,
  "seed": 25,
  "candidates": 1,
  "microbatch": 1,
  "max_steps": 1,
  "max_progress_per_step": 1.0,
  "stop_similarity": 1.0,
  "diffusion_steps": 1000,
  "geometry_policy": "screen"
}
JSON

    "$PF_ROOT/Start-Engine.sh" infer-preflight --config "$CONFIG_PATH"
)
```

The here-document assumes conventional Linux paths without embedded quote or backslash characters. Use a JSON-aware editor for unusual paths. After successful preflight, start the real workload deliberately:

```bash
"$PF_ROOT/Start-Engine.sh" infer --config "$CONFIG_PATH"
```

The guide records approximately 21 minutes for one release-host proposal; that is not a runtime promise for other machines or inputs. Raising candidates, steps or history can increase resource use substantially.

History three uses the registered history-three checkpoint and, for the example, ordered frames `0488`, `0490`, `0492`. History six uses `0482`, `0484`, `0486`, `0488`, `0490`, `0492`. Histories are trained alternatives, not arbitrary padding options or an accuracy ranking.

## Custom inputs and feature provenance

Ordinary inference requires one complete, exactly mapped protein chain of **3–400 residues**, a separate compatible reference, exactly **1, 3 or 6** ordered initial structures, matching registered weights/configuration, and compatible precomputed AlphaFold2 features. Imported complexes may be viewed without becoming eligible for complex pathway inference.

The NPZ feature bundle contains floating arrays:

```text
single : [L, 384]
pair   : [L, L, 128]
```

Sequence, residue order and identities must match the target exactly. Arrays must be finite and fit the FP32 range. Shape matching alone does not establish feature compatibility, and the loader does not silently crop or reorder mismatched inputs. The declared feature-import budget is 512 MiB.

Custom feature provenance identifies `family: af2_single_pair_v1`, the actual producer, the exact sequence SHA-256 and ordered canonical residue IDs. An optional `source_sha256` binds the feature file itself. Preserve extraction versions and parameters alongside the files. The Workbench does not generate these features merely by reading a sequence or metadata JSON.

**Known 0.2.4 defect:** the GUI's **Feature provenance JSON** picker passes a filename where the loader expects an object. Leave that picker empty. For `features.npz`, use an adjacent `features.json` sidecar, or supply an actual `feature_metadata` object through supported advanced configuration. The bundled byte-identified `4INW_A.npz` is the documented metadata-free exception.

AlphaFold3 embeddings cannot replace the required AlphaFold2 features, even when their widths appear compatible. Obtain custom AF2 features using an appropriate, version-recorded upstream workflow; the compact package does not bundle a complete AlphaFold2 installation and databases.

## Configuration reference

### Ordinary inference settings

| Setting | Documented default / policy | Interpretation |
|---|---|---|
| `preset` | `corrected_baseline_v1` | Versioned corrected engine behavior. |
| `history` | `1` in the Workbench service | Selects one of the trained 1/3/6-history checkpoints. The legacy wrapper has a different default. |
| `candidates` | `10` | Proposal budget per selection attempt; not accepted-frame count. |
| `max_steps` | `30` | Maximum retained pathway depth. |
| `seed` | `25` | Source for separately identified per-candidate streams. |
| `noise_scale` | `0.8` | Diffusion-noise parameter. |
| `stop_similarity` | `0.90` | Engine target-contact stopping threshold. |
| `max_progress_per_step` | `0.2` | Admission cap; `null` removes the cap while positive progress remains required. |
| `selection_contact_threshold` | `14 Å` | Selection contact cutoff, separate from analysis contacts. |
| `geometry_policy` | `screen` | Rejects documented coarse geometry failures. `diagnostic` records them without the same rejection policy. |
| `precision` | FP32 | Mixed precision is not the qualified reference policy. |
| `microbatch` | `1` | Candidates evaluated together; changing batch shape can change floating-point behavior. |
| `threads` | `2`, bounded by detected CPU count | Part of the reproducibility record. |
| `diffusion_steps` | `1000` | Production schedule; shorter schedules require explicit diagnostic labeling. |

The GUI's advanced JSON merges last and can override visible controls. Review effective configuration, not only widget values. Unknown keys are rejected. `archived_parameter_defaults_v1` still uses the corrected engine; it is not an exact upstream-execution mode.

### Analysis settings

| Setting | Starting value | Interpretation |
|---|---|---|
| Contact cutoff | `14 Å` | Eligible-pair analysis uses distance **≤** cutoff. |
| Minimum sequence separation | `3` | Same-chain positional exclusion; not author-number subtraction. |
| Mapping | `strict` | Requires appropriate common observed-Cα coverage. `intersection` is a deliberate population change. |
| Chain aliases | `{}` for custom data | Explicit identity correspondence, not sequence alignment. |
| Display smoothing | `1` | No smoothing. Larger windows alter plotted line values, not source coordinates. |
| Contact persistence | `2` frames | Confirmation length in source order, not elapsed time. |
| PCA | Enabled | Descriptive decomposition of aligned coordinates. |
| Isomap | Optional | Requires a connected neighbor graph and eligible frame count. |
| Working-set budget | `512 MiB` default | An analysis admission estimate, not total machine RAM. |
| Comparison gap open / extend | `-0.2` / `-0.01` | Global affine-gap objective. |

Model conditioning, candidate selection and analysis deliberately use different contact semantics. Conditioning uses strict **<10 Å** on a full symmetric matrix including the diagonal. Selection uses a default strict **<14 Å** full-matrix score. Analysis uses unique eligible unordered pairs, no diagonal and **≤** cutoff. Do not relabel these as one interchangeable score.

## Interpret results correctly

Cα RMSD measures geometric agreement over the declared mapping after a proper rotation/translation; it is not an all-atom accuracy certificate. Radius of gyration is an equal-Cα geometric descriptor, not a mass-weighted whole-molecule measurement. Adjacent-frame RMSD measures a structural jump in the supplied sequence, not a transition rate.

Dice and Jaccard describe reference-dependent contact-set agreement. Precision and recall retain their denominators and missing-value conventions. Agreement between two empty sets within a nonempty eligible universe does not prove folding. With no eligible pair universe, scores are unavailable. JSON `null` and blank table cells must not be replaced by zero without a separate justified method.

Contact persistence, formation and dissolution are indexed by ordered frames. The per-residue contact-formation proxy is **not experimental mutational Φ**. Reference-contact progress is not physical time. PCA and Isomap describe sampled geometry; they are not validated reaction coordinates, equilibrium distributions or free-energy landscapes.

Observed-atom measurements require the actual required atoms and continuity. A Cα-only structure cannot supply complete backbone torsions, DSSP or whole-molecule SASA. Reconstructed and minimized structures remain labeled derivatives of the original; an energy decrease does not demonstrate biological correctness.

Independent-seed ensembles describe conditional variation for the selected input and method. Correlated frames are not independent biological replicates. No calibrated confidence for generated frames is supplied, and imported pLDDT/PAE are not copied onto generated intermediates.

## Projects, run folders and publication exports

Use a writable workspace separate from immutable runtime files:

```bash
mkdir -p "$HOME/PathFold-work/inputs" \
         "$HOME/PathFold-work/configs" \
         "$HOME/PathFold-work/projects" \
         "$HOME/PathFold-work/exports" \
         "$HOME/PathFold-work/runs"
```

A **project** consists of a `.pfproject` and its adjacent `.pfproject.assets` directory. Move both together. Projects can retain exact snapshots and draft/view state, but do not install external model checkpoints, feature files, provider software or credentials.

An **inference run directory** preserves the effective configuration, input provenance, trajectory manifest, candidate audit, raw proposals, retained structures, result, events and recovery state. Keep the full directory. Resume only with compatible source, configuration and inputs; changing seeds, thresholds or model assets is a new scientific run.

A **publication bundle** is a verified output directory with manifests, completion marker, result metadata, typed tables, exact arrays, figure data/recipes and selected structures. Preserve the entire directory rather than copying only images. Reopening or replotting works only for the capabilities actually included. Omitting structures or arrays limits future reuse.

Available figure formats include SVG, PDF, PNG and TIFF. Editable SVG text and outlined glyphs are distinct options. Numerical/vector figures do not imply a vector molecular rendering. Actual-frame GIFs are display animations, not physical-time trajectories. A screenshot of the software viewer is not proof that the optional Mol*/WebGL route works.

Exports apply bounded redaction rules to recognized sensitive fields, but arbitrary free text and structural data still require a manual sharing review. A file can contain confidential research information even when obvious paths or credentials are removed.

To open a Linux workspace in Windows File Explorer:

```bash
cd "$HOME/PathFold-work" && explorer.exe .
```

### GUI state location

The launcher uses writable state independently of scientific outputs. A deliberate alternate state directory can be selected for one launch:

```bash
PF_ROOT="$HOME/PathFold/PathFold-0.2.4-Linux-x86_64-Compact-CPU"
PATHFOLD_PORTABLE_DATA="$HOME/PathFold-work/gui-state" \
    "$PF_ROOT/Start-PathFold.sh"
```

Avoid publishing generated state, user projects, private trajectories or credentials inside a software release.

## Optional tools and AF3 interoperability

### PULCHRA, DSSP and OpenMM

The optional archives are in `packs/archives/`. Extract only required tools into a new Linux tools folder and retain their README, configuration, notices and neighboring libraries. Use expected hashes from the trusted pack records, not a newly invented hash substituted after a verification error.

**PULCHRA** provides an explicitly configured geometric reconstruction derivative for eligible continuous canonical protein Cα chains. The documented profile preserves parent identity and separates modeled heavy atoms from the parent. It does not supply calibrated confidence or validate physical folding.

**DSSP** annotates eligible supplied/reconstructed N/Cα/C/O backbone atoms using its pinned backend. Raw Cα structures are ineligible. Its secondary-structure assignments and hydrogen-bond scores describe that supplied model; they are not measured binding energies.

**OpenMM** performs a separately recorded restrained Amber14/OBC2 minimization for the supported complete-heavy-atom inputs. The qualified v2 preparation/minimization protocol uses **one CPU thread**. It is not a molecular-dynamics simulation, does not automatically repair every missing atom and does not establish structural accuracy from a lower force-field energy.

The presence of tool archives does not mean those tools are already installed, configured or exercised on the current host.

### AlphaFold3 interoperability

Workbench can import independent AF3 output samples and retain their structures, sample identities, confidence sidecars and provenance. Independent predictions are **not** an ordered folding trajectory; sample playback is not used to imply a pathway.

Optional local or HTTPS execution adapters require a separately installed, authorized runtime or a compatible authorized service. No AF3 weights, databases, credentials, subscription or live provider endpoint are bundled. Fixture tests of an adapter do not establish live service qualification.

An experimental AF3-derived protein-chain endpoint retains its parent context and still requires genuine AF2 conditioning for the shipped PathFold checkpoints, explicit hybrid/experimental flags and the identified separate AF2 baseline endpoint. There is no native AF3-trained PathFold model in this release.

## Research declarations and paired comparisons

The advanced Compare workflow can audit supplied dataset declarations and summarize supplied paired measurements. It does not obtain legal permissions, compute homology groups, establish training independence, run missing comparison experiments or train a replacement model.

The documented comparison requires matched baseline/candidate measurements per protein and seed with equal declared proposal/compute budgets and explicit units. Differences are summarized within proteins and then across proteins with equal protein weight; the bootstrap resamples proteins rather than treating frames as independent proteins.

Synthetic practice data remain explicitly synthetic. The report retains `scientific_improvement_established: false`. Interpretation depends on the metric direction, experimental design and independent evidence, not merely a favorable number or confidence interval.

## Reproducibility and validation boundaries

Three levels of evidence must remain separate:

| Evidence | Recorded result | What it does not establish |
|---|---|---|
| Reviewed source/release-host records | 482 tests passed and one process-identity test skipped; the report retains 31 broader unresolved requirements. | That those tests were rerun on every user's computer or every requirement was completed. |
| Specific eager CPU numerical workload | A recorded full 1,000-index frozen CPU case reproduced corrected-source coordinates exactly. | Upstream-equivalent trajectories, all-history/all-protein accuracy, speedup or cross-device bitwise identity. |
| Maintainer's compact WSL transcript | ZIP integrity; fresh extraction; CPU setup; desktop/CPU diagnostics; CPU operators; spawned-process checks; 3,674 CPU payload files; Windows-copy SHA-256 match. | A repeated full scientific benchmark, native Windows support, native WebGL or complete GUI-to-engine inference validation. |

The source/release-host checks used a particular operating system, source revision, model, input bytes, runtime and settings. The compact WSL tests provide additional deployment evidence, not a replacement for those scientific experiments. Separate screenshots in the supplied user guide show a visible Qt window in draft state, not completed inference results.

Record at least the release asset hash, build-source identity, model/history/checkpoint identities, feature/input hashes, chain mapping, precision, threads, microbatch, seeds, complete effective configuration and termination reason. Preserve candidate audits and manifests.

Candidate seed identity is designed not to depend on microbatch grouping, but floating-point behavior can still vary with batch shape, libraries, device and threading. A selection boundary can amplify a small numerical difference into a different pathway. The reference route is **eager CPU FP32** within the exact recorded workload and runtime scope.

## Known limitations and troubleshooting

### Known 0.2.4 limitations

The feature-provenance filename picker has the documented object-versus-path defect; use the sidecar/object workaround. MPS appears in the GUI but is rejected by the engine resolver. Native Windows, ARM64, additional accelerator routes and ordinary-user WebGL need separate qualification. Failed compiler/ONNX experimental candidates are not production acceleration options.

No validated physical time, rates, TICA, equilibrium/free-energy analysis, generated-frame confidence calibration, retraining, variable masked-history checkpoint, native AF3 conditioning or held-out predictive superiority is supplied. Experimental search policies do not close those evidence gaps.

Historical guides contain mixed compact and multipart instructions. For this compact release, use the paths in this README and do not call the omitted `Verify-Package.sh` or expect the old top-level examples directory. Those documentation differences do not justify changing verified runtime files.

### Common problems

| Symptom | Action |
|---|---|
| `wsl: command not found` inside Ubuntu | WSL management commands belong in PowerShell; `wsl.exe` can be used through configured interoperability. Package scripts belong in Ubuntu. |
| ZIP path not found | Check its actual Windows drive/folder and whether the browser appended a suffix. Update `DOWNLOAD_DIR`; do not guess another archive. |
| `Verify-Package.sh` missing | Expected in compact CPU. Check the ZIP and run the two included Doctors. |
| `Setup-CPU.sh: not found` | The compact package is incomplete or the current directory is wrong. Restore a complete verified extraction. |
| `The bundled complete CPU archive is missing.` | Preserve/restore `packages/PathFold-CPU-Edition-0.2.4-Linux-x86_64.tar.gz`; do not delete it after setup. |
| Desktop reports no Torch | Expected split runtime. Check `Doctor-CPU.sh` and configure the external engine/checkpoint fields. |
| CPU integrity or ownership check fails | Retain the log. Use a fresh verified installation; do not bypass inventory/ownership protections. |
| Shell launcher permission denied | Check the exact file and extraction method. Restore through Linux extraction; do not recursively make all files executable. |
| No GUI window | Inspect display variables and Qt overrides; keep launcher output. A prompt return is not sufficient confirmation. |
| Explore is empty / Export disabled | Complete a job, open a saved project or import a verified bundle, then wait for snapshot loading. |
| Reference metrics missing | Supply a compatible separate reference and run a new analysis. |
| Feature provenance error | Leave the filename picker empty and use the documented sidecar or metadata object. |
| No admissible candidate | Inspect recorded geometry, progress policy and candidate audit; do not report successful folding. |
| Mol*/WebGL unavailable | Use Software view. Do not disable Chromium's security sandbox as a generic repair. |

For WSLg display diagnosis, inspect rather than overwrite its environment:

```bash
printf 'DISPLAY=%s\n' "$DISPLAY"
printf 'WAYLAND_DISPLAY=%s\n' "$WAYLAND_DISPLAY"
printf 'XDG_RUNTIME_DIR=%s\n' "$XDG_RUNTIME_DIR"
printf 'QT_QPA_PLATFORM=%s\n' "${QT_QPA_PLATFORM-}"
```

An inherited `QT_QPA_PLATFORM=offscreen` prevents a visible window. Remove that override for the current shell when intentionally returning to normal GUI use:

```bash
unset QT_QPA_PLATFORM
```

When a WSL update is needed, save work and stop jobs first. In **PowerShell**:

```powershell
wsl --update
wsl --shutdown
```

`wsl --shutdown` stops all running WSL distributions, not just PathFold. Reopen the actual distribution afterward. Use [Microsoft's WSLg guidance](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps) and [WSLg display diagnostics](https://github.com/microsoft/wslg/wiki/Diagnosing-%22cannot-open-display%22-type-issues-with-WSLg); avoid legacy hard-coded display-IP workarounds unless the specific setup requires them.

## Source installation and development

The Git source checkout is distinct from an installed compact binary directory. Use the **modified source tree**, not the 901 MiB deployment ZIP, for code review, development and rebuilding.

The supplied source metadata declares `pathfold-workbench` 0.2.4, Python **>=3.12,<3.13**, GPL-3.0-only, and separate analysis, desktop, CPU, test and build profiles. Recorded direct dependency versions include NumPy 2.2.6, SciPy 1.16.2, Matplotlib 3.10.6, pandas 2.3.3, Biopython 1.85, Zarr 2.18.7, PySide6 6.9.3, Torch 2.8.0+cpu and Lightning/pytorch-lightning 2.5.5. These lists are not a substitute for profile-specific resolved hash locks.

After the modified source has been published, obtain the Workbench branch:

```bash
git clone --branch workbench https://github.com/SidSin0809/PathFold-Workbench.git
cd PathFold-Workbench
```

Follow the exact source kit's `docs/bootstrap.md`, `docs/build.md`, `pyproject.toml` and applicable files under `requirements/`. Start by inspecting the supplied bootstrap's supported arguments rather than assuming the compact launchers exist at the source root:

```bash
python3.12 bootstrap.py --help
```

The older upstream `requirements.txt` is preserved history and is not the authoritative Workbench environment definition. Windows source scripts or lock files are recipes, not proof that a native Windows binary has been built or qualified. Builds should retain source identity, dependency locks, notices and their actual validation records.

Changing scientific source, feature/model contracts or numerical policy requires new appropriate tests and release identification. Changing only README text does not rebuild or scientifically qualify an existing binary.


## Contributing and reporting issues

Open issues and pull requests against this derivative for Workbench-specific GUI, launcher, packaging, corrected analysis or deployment problems. Do not attribute derivative bugs to upstream. Focused upstream-compatible changes can be proposed separately to Kihara Lab with clear rationale and attribution.

A useful issue identifies the release/asset hash, Ubuntu/WSL/glibc versions, architecture, Doctor output, exact command or GUI action, input representation, relevant configuration and observed error. Include only a minimal input you are permitted to share. Remove credentials, personal paths and private research data from logs before posting publicly.

For scientific discrepancies, include history/checkpoint identity, seed, precision, thread count, microbatch, feature provenance, mapping, termination reason and a minimal reproducible example. Separate a packaging failure from a proposed scientific-method change. Contributions should preserve original notices, document altered semantics and add targeted tests.

## License, attribution and citation

### License and redistribution

Upstream PathFold is distributed with the GNU GPL version 3 license. The supplied Workbench source metadata declares **GPL-3.0-only**. Retain the upstream `LICENSE`, copyright notices, warranty disclaimers and applicable component notices. This derivative's license declaration does not replace distinct third-party licenses or data/model-specific terms.

For public distribution of the modified executable, provide the corresponding modified source and required build/install scripts under the applicable terms. The compact binary may remain a separate download; source need not be forced into every user's software ZIP. However, a link to **only unmodified upstream** does not provide the source for the Workbench modifications. See the [GNU GPL FAQ](https://www.gnu.org/licenses/gpl-faq.html#DistributeExtendedBinary) and the upstream [license text](https://github.com/kiharalab/PathFold/blob/35cd859bae0530185c275ffa8b62b063ea1c3347/LICENSE).

Review the actual redistributed component inventory, source availability and licenses before publication. A notice catalogue, checksum pass or README assertion alone does not establish complete redistribution compliance. Retain legally required notices even in a compact software-only package. Source archives must be source-complete; a binary wheel collection or a copy of installed executables is not automatically Corresponding Source.

### Cite the original method

**Zhang Z, Ibtehaz N, Kagaya Y, Xu Z, Punuru P, Kihara D.** *PathFold: Predicting the Entire Protein Folding Pathway from Protein Sequence Alone.* bioRxiv, 2026. DOI: [10.64898/2026.08.26.747321](https://doi.org/10.64898/2026.08.26.747321). This is the original PathFold preprint, not a validation publication for this derivative.

### Identify the Workbench version

For work using this derivative, additionally record **PathFold Workbench 0.2.4**, the downstream tag, actual source/build identifiers, compact asset SHA-256 and the relevant effective configuration. A proposed software citation is:

> Singh, S. PathFold Workbench, version 0.2.4. Independent derivative of Kihara Lab PathFold. GitHub: SidSin0809/PathFold-Workbench. 

