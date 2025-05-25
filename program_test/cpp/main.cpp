#include "A.h"
#include <iostream>

A::A(const std::string& s) : str(s) {}

std::string A::getString() const {
    return str;
}

int main() {
    A obj("Hello, World!");
    std::cout << obj.getString() << std::endl;

    const char* cstr;
    {
        cstr = obj.getString().c_str();
    }

    std::cout << cstr << std::endl;

    return 0;
} 