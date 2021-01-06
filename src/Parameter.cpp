//
// Created by Smith, Maureen on 06.01.21.
//
#include <iostream>
#include <filesystem>
#include <string_view>
#include "Parameter.hpp"
namespace fs = std::filesystem;
namespace parameter {

    void Parameter::readParameterFile(const std::string_view file_sw) {
        fs::path file_path{file_sw};
        if(fs::exists(file_path)) {
            //TODO call JSON parser von Niels

        } else {
            std::string errorMsg = "Parameter file does not exist:\n" + file_path.string() + "\n";
            throw errorMsg;
        }
    }
}
