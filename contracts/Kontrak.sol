// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 < 0.8.10;
pragma experimental ABIEncoderV2;

contract Kontrak {
    address private admin;
    uint public jumlahPegawai;

    constructor () {
        jumlahPegawai = 0;
        admin = msg.sender;
    }

    modifier onlyAdmin() {
    require(msg.sender == admin);
    _;
    }

    function superAdmin() public view returns(address) {
        return admin;
    }

    struct Pegawai {
        address keyAddress;
        string nama;
        string id;
        string gender;
        string jabatan;
        string pendidikan;
        string ttl;
        string alamatRumah;
        string status;
        bytes32 password;
        bool sedangKerja;
        bool masukSistem;
    }
    
    address [] public pegawai;
    mapping(address => Pegawai) private dataPegawai;

    function nomorJabatan(string memory _jabatan) private pure returns(string memory){
        if (hashSandi(_jabatan) == hashSandi("Manager")) {
            return "01";
        } else if (hashSandi(_jabatan) == hashSandi("Administrasi")) {
            return "02";
        } else if (hashSandi(_jabatan) == hashSandi("Kasir")) {
            return "03";
        } else {
            return "Error Input";
        }
    }

    function hashSandi(string memory _password) private pure returns(bytes32) {
        return bytes32(keccak256(abi.encodePacked(_password, uint(keccak256(abi.encodePacked(uint(4), uint(9)))))));
    }

    function tambahPegawai(string memory _nama, string memory _id, string memory _jabatan) public {
        Pegawai memory newPegawai = Pegawai({
            keyAddress : msg.sender,
            nama : _nama,
            id : string(abi.encodePacked(_id, _jabatan)),
            gender: "",
            jabatan : _jabatan,
            pendidikan : "",
            ttl : "",
            alamatRumah : "",
            status : "",
            password : hashSandi("123"),
            sedangKerja : false,
            masukSistem : false
        });
        dataPegawai[msg.sender] = newPegawai;
        pegawai.push(msg.sender);
        jumlahPegawai++;
    }

    function ubahSandi(string memory _password1, string memory _password2) public {
        require(dataPegawai[msg.sender].masukSistem = true);
        if (hashSandi(_password1) == hashSandi(_password2)) {
            dataPegawai[msg.sender].password = hashSandi(_password1);
        }
    }

    function ubahDataPegawai(string memory _nama, string memory _gender, string memory _pendidikan, string memory _ttl, string memory _alamatRumah, string memory _status) public {
        dataPegawai[msg.sender].nama = _nama;
        dataPegawai[msg.sender].gender = _gender;
        dataPegawai[msg.sender].pendidikan = _pendidikan;
        dataPegawai[msg.sender].ttl = _ttl;
        dataPegawai[msg.sender].alamatRumah = _alamatRumah;
        dataPegawai[msg.sender].status = _status;
    }

    function hapusDataPegawai(address _alamatPegawai) onlyAdmin public {
        delete dataPegawai[_alamatPegawai];
    }

    function absenKerja(string memory _password) public returns(bool _sedangKerja) {
        require(dataPegawai[msg.sender].masukSistem = true);
        if (hashSandi(_password) == dataPegawai[msg.sender].password) {
            dataPegawai[msg.sender].sedangKerja = true;
            return true;
        }
    }

    function mendapatkanJumlahPegawai() public view returns(uint) {
        return jumlahPegawai;
    }

    function Login(string memory _id, string memory _password, address _alamatPegawai) public returns(bool _masukSistem) {
        if (keccak256(abi.encodePacked(_id)) == keccak256(abi.encodePacked(dataPegawai[_alamatPegawai].id)) && hashSandi(_password) == dataPegawai[_alamatPegawai].password) {
            dataPegawai[_alamatPegawai].sedangKerja = true;
            return true;
        }
    }

    function logOut() public returns(bool) {
        return dataPegawai[msg.sender].masukSistem = false;
    }
}