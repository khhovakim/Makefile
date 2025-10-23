# 🛠️ Makefile for C and C++ Projects

This repository provides a **universal Makefile** for building C and C++ projects with support for multiple build modes, automatic dependency generation, pretty output, and helper utilities.

---

## ✨ Features

* ✅ Supports **C (C11)** and **C++ (C++17)**
* ✅ Multiple build modes:

  * **release** → optimized build with `-O2 -DNDEBUG`
  * **debug** → debug-friendly build with `-g -O0`
  * **asan** → build with **AddressSanitizer**
* ✅ Automatic object directory structure (`obj/`)
* ✅ Separate binary outputs (`bin/release`, `bin/debug`, `bin/asan`)
* ✅ Auto-dependency handling with `-MMD -MP`
* ✅ Colored and formatted console output
* ✅ `show` commands to inspect configuration (sources, objects, flags, includes)
* ✅ Valgrind support for memory leak checks

---

## 🚀 Usage

### Build Targets

```bash
make               # Default → release build
make BUILD_TYPE=r  # Optimized release build
make BUILD_TYPE=d  # Debug build with symbols
make BUILD_TYPE=as # AddressSanitizer build
```

### Run the Program

```bash
make run        # Builds (release) and runs the binary
```

### Cleaning

```bash
make clean      # Remove object files
make fclean     # Remove objects + executables
make re         # Full rebuild
```

---

## 🔍 Show Project Info

Inspect details of the build configuration:

```bash
make show                # Show everything
make show_src            # Show source files
make show_obj            # Show ASan object files
make show_compilers      # Show compilers
make show_flags          # Show release flags
make show_includes       # Show include directories
make show_include_flags  # Show include flags
```

---

## 🎨 Pretty Output

To display a decorative build banner:

```bash
make pretty
```

---

## ⚙️ Customization

* Change the **project name** in the Makefile:

  ```make
  NAME = my_program
  ```
* Add source files to `src/` and headers to `include/`.
* Supports nested include directories automatically.

---

## 📌 Requirements

* **gcc/g++** (can be changed to clang/clang++ or cc/c++)
* **GNU Make**

---

## 📖 Example

```bash
# Build and run in release mode
make run

# Build with ASan and run
make BUILD_TYPE=as && ./bin/ASan/a.out

# Inspect all configuration
make show
```

---

### ✅ Ready to use for any C / C++ project!
