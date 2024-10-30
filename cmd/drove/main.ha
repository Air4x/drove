use fmt;
use fs;
use strings;
use os;
use io;

type option = enum {
	BINARY,
	MODULE,
};

export fn main() void = {
	fmt::println("Hello, drove\n")!;
	let name = os::args[2];
	let op = switch (os::args[1]) {
		case "-b" =>
		     yield option::BINARY;
		case "-m" =>
		     yield option::MODULE;
		case =>
		     os::exit(1);
	};
	make_dirs(op, name);
	make_files(name);
	writemkfile(op, name)!;
};
       

fn make_files(name: str) void = {
	let mode = fs::mode::USER_RW;
	let flag = fs::flag::WRONLY;
	// Creating README.md, adding some text just not to have a
	// empty file
	let readme_path = strings::concat(name, "/README.md");
	defer free(readme_path);
	let readme_buf = strings::concat("# ", name);
	defer free(readme_buf);
	let readme_file = os::create(readme_path, mode, flag)!;
	defer io::close(readme_file)!;
	io::write(readme_file , strings::toutf8(readme_buf))!;
	// Creating th COPYING file, adding some placeholder text
	let copying_path = strings::concat(name, "/COPYING");
	defer free(copying_path);
	let copying_file = os::create(copying_path, mode, flag)!;
	defer io::close(copying_file)!;
	io::write(copying_file, strings::toutf8("add your license here"))!;
	
};



fn writemkfile(op: option, name: str) (void | fs::error | io::error) = {
	let text = switch (op) {
		case option::BINARY =>
		     yield ".POSIX:\n.SUFFIX:\nHARE=hare\nHAREFLAGS=\n\nDESTDIR=\nPREFIX=/usr/local\nBINDIR=$(PREFIX)/bin\n\nall: cmd\n\ncmd:\n\t$HARE) build $(HAREFLAGS) -o $@ cmd/$@/\n\ncheck:\n\t$(HARE) test $(HAREFLAGS)\nclean:\n\t rm -f cmd\n\ninstall:\n\tinstall -Dm755 cmd $(DESTDIR)$(BINDIR)/cmd\n\nuninstall:\n\trm -f $(DESTDIR)$(BINDIR)/cmd\n\n.PHONY: all check clean install uninstall";
		case option::MODULE =>
		     yield ".POSIX:\n.SUFFIX:\nHARE=hare\nHAREFLAGS=\n\nDESTDIR=\nPREFIX=/usr/local\nSRCDIR=$(PREFIX)/src\n\nHARESRCDIR=$(SRCDIR)/hare\nTHIRDPARTYDIR=$(HARESRCDIR)/third-party\n\ncheck:\n\t$(HARE) test $(HAREFLAGS)\n\ninstall:\n\tinstall -Dm644 example/*  $(DESTDIR)$(THIRDPARTYDIR)/example/\n\nuninstall:\n\trm -f $(DESTDIR)$(THIRDPARTYDIR)/example\n\n.PHONY: check install uninstall";
	};
	let file_name = strings::concat(name, "/Makefile");
	defer free(file_name);
	let file = os::create(file_name, fs::mode::USER_RW, fs::flag::RDWR)?;
	defer io::close(file)!;
	io::writeall(file, strings::toutf8(text) )!;
};

fn make_dirs(op: option, name: str) void = {
	os::mkdir(name, fs::mode::USER_RWX)!;
	switch (op) {
		case option::BINARY =>
		     make_binary_dirs(name);
		case option::MODULE =>
		     make_module_dirs(name);
	};
};

// creates:
	// cmd/name/
	// doc/
	// scripts/
	// internal/
	// example/
fn make_binary_dirs(name: str) void = {
	let cmd_path = strings::concat(name, "/cmd/", name);
	defer free(cmd_path);
	os::mkdirs(cmd_path, fs::mode::USER_RWX)!;
	let doc_path = strings::concat(name, "/doc");
	defer free(doc_path);
	os::mkdir(doc_path, fs::mode::USER_RWX)!;
	let scripts_path = strings::concat(name, "/scripts");
	defer free(scripts_path);
	os::mkdir(scripts_path, fs::mode::USER_RWX)!;
	let internal_path = strings::concat(name, "/internal");
	defer free(internal_path);
	os::mkdir(internal_path, fs::mode::USER_RWX)!;
	let example_path = strings::concat(name, "/example");
	defer free(example_path);
	os::mkdir(example_path, fs::mode::USER_RWX)!;
};

// creates:
	// name/
	// doc/
	// scripts/
	// example/
fn make_module_dirs(name: str) void = {
	let name_path = strings::concat(name, "/", name);
	defer free(name_path);
	os::mkdir(name_path, fs::mode::USER_RWX)!;
	let doc_path = strings::concat(name, "/doc");
	defer free(doc_path);
	os::mkdir(doc_path, fs::mode::USER_RWX)!;
	let scripts_path = strings::concat(name, "/scripts");
	defer free(scripts_path);
	os::mkdir(scripts_path, fs::mode::USER_RWX)!;
	let example_path = strings::concat(name, "/example");
	defer free(example_path);
	os::mkdir(example_path, fs::mode::USER_RWX)!;
};

