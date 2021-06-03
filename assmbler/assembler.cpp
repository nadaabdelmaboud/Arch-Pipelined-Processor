#include <iostream>
#include <string>
#include <map>
#include <fstream>
#include <math.h>
#include <vector>
#include <bitset>
using namespace std;
// maps and lists
map<string, pair<int, int>> instructions;
map<string, int> registers;
// map<string, int> addressesModes;
map<string, int> labels;
map<string, int> variables;
// global var
int programCounter = 0;
int I = 0;
bool er = false;
int currentPass = 0;
int LA = 0;
ofstream out;
ifstream in;
int indexOfFirstLetter(string s) // return the index of some latter
{
    for (int i = 0; i < s.length(); i++)
    {
        if (s[i] != ' ')
        {
            return i;
        }
    }
    return 0;
}
void removeSubstrs(string &s, string &p)
{
    string::size_type n = p.length();
    for (string::size_type i = s.find(p);
         i != string::npos;
         i = s.find(p))
        s.erase(i, n);
}
void eraseAllSubStr(string &STR, const string &Erase)
{
    size_t Position = string::npos;
    while ((Position = STR.find(Erase)) != string::npos) // Search for the substring in string in a loop until nothing is found
        STR.erase(Position, Erase.length());
}
bool isNumber(const string &s)
{
    string::const_iterator it = s.begin(); //An iterator to the beginning of the string.
    while (it != s.end() && isdigit(*it))
        ++it;
    return !s.empty() && it == s.end();
}
void removeComment(string &input) // remove the ";"and the comments
{
    int comment = input.find(";");
    if (comment != -1)
    {
        eraseAllSubStr(input, input.substr(comment, input.length()));
    }
}
void eraseFromSpaceTellEnd(string &s)
{
    for (int i = 0; i < s.length(); i++)
    {
        if (s[i] == ' ' || s[i] == '\t')
        {
            s.erase(i, s.length() - i);
        }
    }
}
void eraseFromCommaTellEnd(string &s)
{
    for (int i = 0; i < s.length(); i++)
    {
        if (s[i] == ',')
        {
            s.erase(i, s.length() - i);
        }
    }
}
bool getValue(string op)
{
    int space = op.find(" ");
    if (space == -1)
        space = op.find("\t");
    if (space != -1)
    {
        op = op.substr(space, op.length());
        eraseAllSubStr(op, " ");
        eraseAllSubStr(op, "\t");
        if (isNumber(op))
        {
            bitset<16> y(stoi(op));
            out << y << endl;
            return true;
        }
    }
    return false;
}
bool Operand(string &op, int &Luggage, int opNum)
{
    map<string, int>::iterator It;
    int r = op.find("R");
    if (r != -1)
    {
        string reg = op.substr(r, 2);
        It = registers.find(reg);

        if (It != registers.end())
        {
            bitset<5> y(registers.find(reg)->second);
            out << y;
            return true;
        }
    }
    programCounter++;
    if (currentPass == 1)
        return true;
    //search for variable
    It = variables.find(op);
    if (It != variables.end())
    {
        Luggage = It->second;
        bitset<3> y(registers.find("R7")->second);
        out << y;
        LA++;
        return true;
    }

    if (opNum == 2)
        return false;

    if (isNumber(op))
    {
        bitset<16> y(variable.find(op)->second);
        out << y;
        Luggage = stoi(op);
        LA++;
        return true;
    }

    return false;
}
void Pass(int num)
{
    ifstream in("c1.txt");
    if (num == 2)
        out.open("c1output.txt", ios::in); // output file

    string input; //Get line from stream into string
    getline(in, input);
    for (auto &c : input)
        c = toupper(c);             //converts a given character to uppercase.
    while (input.find("END") == -1) //since memory is word addressable,
    {
        I++;
        string Opcode = "", FirstOperand = "", SecondOperand = "", Label = "";
        removeComment(input);

        /// *** ***  ***  ***  ***  ***  ***  ***  *** ///
        /// ***        Save the Label section      *** ///
        /// *** ***  ***  ***  ***  ***  ***  ***  *** ///
        int colon = input.find(':');

        if (colon != -1)
        {
            Label = input.substr(0, colon); // cut at the : save the at the label
            eraseAllSubStr(input, input.substr(0, colon + 1));
            eraseAllSubStr(Label, " ");  // remove Space
            eraseAllSubStr(Label, "\t"); // remove tap
            if (Label == "")
                cout << "empty line"; // this is means that all the line is empty
            else
                labels.insert(pair<string, int>(Label, LA)); // insert int the labels map
        }

        input.erase(0, indexOfFirstLetter(input));
        /// *** ***  ***  ***  ***  ***  ***  ***  *** ///
        /// ***   Save the second Operand section  *** ///
        /// *** ***  ***  ***  ***  ***  ***  ***  *** ///
        int comma = input.find(','); // find the ","
        string se = input.substr(comma + 1, '\n');
        eraseFromSpaceTellEnd(se);
        SecondOperand = se;

        /// *** ***  ***  ***  ***  ***  ***  ***  *** ///
        /// *** Save the First Operand section ***     ///
        /// *** ***  ***  ***  ***  ***  ***  ***  *** ///
        int s1 = input.find(" ");
        if (s1 == -1)
            s1 = FirstOperand.find("\t"); //tab
        int comma2 = input.find(",");
        if (comma2 == -1)
        {
            string newdn = input.substr(s1 + 1, input.length());
            int s = newdn.find(" ");
            FirstOperand = newdn.substr(0, s);
        }
        if (comma2 != -1)
        {
            string newdn = input.substr(s1 + 1, input.length());
            eraseFromCommaTellEnd(newdn);
            FirstOperand = newdn;
        }
        /// *** ***  ***  ***  ***  ***  ***  ***  *** ///
        /// ***       Save the Opcode section      *** ///
        /// *** ***  ***  ***  ***  ***  ***  ***  *** ///
        int space = input.find(" ");
        if (space == -1)
            int space = input.find("\t");

        Opcode = input.substr(0, space);
        eraseAllSubStr(Opcode, " ");  // remove space
        eraseAllSubStr(Opcode, "\t"); // remove tap
        if (Opcode == "")
        {
            getline(in, input);
            for (auto &c : input)
                c = toupper(c);
            continue;
        }
        LA++;
        /// this is line return false in 9,11,20
        programCounter++;

        map<string, pair<int, int>>::iterator instructionsIt = instructions.find(Opcode);

        string pat = " ";
        string pat2 = "\t";
        eraseAllSubStr(FirstOperand, pat);
        eraseAllSubStr(FirstOperand, pat2);
        removeSubstrs(SecondOperand, pat);
        removeSubstrs(SecondOperand, pat2);
        if (instructionsIt == instructions.end())
            er = true; // break;
        //check for labels and var
        else
        {
            if (instructionsIt->second.first <= 8) // so this is one of the two operand instructions
            {
                out << "000";
                bitset<3> x(instructionsIt->second.first);
                out << x;
            }
            else // this means this not two operand instruction it might be one , branch or no operand instruction
            {
                if (instructionsIt->second.first == 9)
                    out << "001";
                else if (instructionsIt->second.first == 10)
                    out << "010";
                else if (instructionsIt->second.first == 11)
                    out << "011";
                else if (instructionsIt->second.first == 12)
                    out << "012";
                else
                    out << "013";

                bitset<3> y(instructionsIt->second.second);
                out << y;

                // if (instructionsIt->second.first == 9)
                // {
                //     out << "00000";
                // }
                // else if (instructionsIt->second.first == 10)
                // {
                //     out << "00";
                // }
                // else
                //     out << "0000000000";
            }

            bool success;
            int L1 = 2147483647, L2 = 2147483647;
            if (instructionsIt->second.first < 9) //two operand instructions
            {
                success = Operand(FirstOperand, L1, 1);
                if (!success)
                {
                    cout << "Error at line " << I << " first operand" << endl;
                    er = true; // break;
                }
                success = Operand(SecondOperand, L2, 2);
                if (!success)
                {
                    cout << "Error at line " << I << " sec operand" << endl;
                    er = true; // break;
                }
            }
            else
            {
                if (instructionsIt->second.first == 10)
                {
                    //branchs instructins
                    map<string, int>::iterator It = labels.find(FirstOperand);
                    if (It != labels.end())
                    {
                        if (abs(It->second - (programCounter)) > pow(2, 8))
                        {
                            cout << "error at line " << I << " label too far" << endl;
                            er = true;
                        }
                        else
                        {
                            bitset<8> x(It->second);
                            out << x;
                        }
                    }
                    else
                    {
                        if (num == 2)
                        {
                            cout << "error at line " << I << "label not found" << endl;
                            er = true;
                        }
                    }
                }
                else if (instructionsIt->second.first == 9)
                {
                    success = Operand(FirstOperand, L1, 2);
                    if (!success)
                    {
                        cout << "Error at line " << I << " first op" << endl;
                        er = true; // break;
                    }
                }
            }
            if (L1 != 2147483647)
            {
                out << endl;
                bitset<16> x(L1);
                out << x;
            }
            if (L2 != 2147483647)
            {
                out << endl;
                bitset<16> y(L2);
                out << y;
            }
            out << endl;
        }
        getline(in, input);
        for (auto &c : input)
            c = toupper(c);
    }
    in.close();
    if (num == 2)
        out.close();
    if (er)
        cout << "PASS " << num << " Failed" << endl;
    else
        cout << "PASS " << num << " Successful!" << endl;
}
int main()
{

    /// mov R1,R0
    /// 00 0000 00 001 00 000
    /// 00 0000 01 000 00 001
    //3 bits each
    registers.insert(pair<string, int>("R0", 0)); //000
    registers.insert(pair<string, int>("R1", 1));
    registers.insert(pair<string, int>("R2", 2));
    registers.insert(pair<string, int>("R3", 3));
    registers.insert(pair<string, int>("R4", 4));
    registers.insert(pair<string, int>("R5", 5));
    registers.insert(pair<string, int>("R6", 6));
    registers.insert(pair<string, int>("R7", 7));
    //2 bits each
    // addressesModes.insert(pair<string, int>("", 0));    //00
    // addressesModes.insert(pair<string, int>("()+", 1)); //01
    // addressesModes.insert(pair<string, int>("-()", 2));
    // addressesModes.insert(pair<string, int>("X()", 3));
    //4 bits each
    instructions.insert(pair<string, pair<int, int>>("NOP", pair<int, int>(0, 0))); //000
    instructions.insert(pair<string, pair<int, int>>("SETC", pair<int, int>(1, 0)));
    instructions.insert(pair<string, pair<int, int>>("CLRC", pair<int, int>(2, 0)));
    instructions.insert(pair<string, pair<int, int>>("MOV", pair<int, int>(3, 0)));
    instructions.insert(pair<string, pair<int, int>>("ADD", pair<int, int>(4, 0)));
    instructions.insert(pair<string, pair<int, int>>("SUB", pair<int, int>(5, 0)));
    instructions.insert(pair<string, pair<int, int>>("AND", pair<int, int>(6, 0)));
    instructions.insert(pair<string, pair<int, int>>("OR", pair<int, int>(7, 0)));
    //8bits each
    instructions.insert(pair<string, pair<int, int>>("CLR", pair<int, int>(9, 0)));
    instructions.insert(pair<string, pair<int, int>>("NOT", pair<int, int>(9, 1)));
    instructions.insert(pair<string, pair<int, int>>("INC", pair<int, int>(9, 2)));
    instructions.insert(pair<string, pair<int, int>>("DEC", pair<int, int>(9, 3)));
    instructions.insert(pair<string, pair<int, int>>("NEG", pair<int, int>(9, 4)));
    instructions.insert(pair<string, pair<int, int>>("RLC", pair<int, int>(9, 5)));
    instructions.insert(pair<string, pair<int, int>>("RRC", pair<int, int>(9, 6)));

    instructions.insert(pair<string, pair<int, int>>("JZ", pair<int, int>(10, 0)));
    instructions.insert(pair<string, pair<int, int>>("JN", pair<int, int>(10, 1)));
    instructions.insert(pair<string, pair<int, int>>("JC", pair<int, int>(10, 2)));
    instructions.insert(pair<string, pair<int, int>>("JMP", pair<int, int>(10, 3)));

    instructions.insert(pair<string, pair<int, int>>("OUT", pair<int, int>(11, 0)));
    instructions.insert(pair<string, pair<int, int>>("IN", pair<int, int>(11, 1)));

    instructions.insert(pair<string, pair<int, int>>("IADD", pair<int, int>(12, 0)));
    instructions.insert(pair<string, pair<int, int>>("SHL", pair<int, int>(12, 1)));
    instructions.insert(pair<string, pair<int, int>>("SHR", pair<int, int>(12, 2)));
    instructions.insert(pair<string, pair<int, int>>("LDM", pair<int, int>(12, 3)));
    instructions.insert(pair<string, pair<int, int>>("LDD", pair<int, int>(12, 4)));
    instructions.insert(pair<string, pair<int, int>>("STD", pair<int, int>(12, 5)));

    instructions.insert(pair<string, pair<int, int>>("CALL", pair<int, int>(13, 0)));
    instructions.insert(pair<string, pair<int, int>>("RET", pair<int, int>(13, 1)));
    instructions.insert(pair<string, pair<int, int>>("Push", pair<int, int>(13, 2)));
    instructions.insert(pair<string, pair<int, int>>("Pop", pair<int, int>(13, 3)));
    currentPass++;
    Pass(currentPass);
    programCounter = 0;
    I = 0;
    currentPass++;
    LA = 0;
    if (!er)
        Pass(currentPass);
    if (er)
    {
        out.open("c4output.txt", ofstream::out | ofstream::trunc);
        out.close();
    }
    return 0;
}