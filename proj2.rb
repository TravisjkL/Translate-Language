require_relative 'Commands.rb'

aFile = File.open("input.wl","r")
readfile = aFile.read()

command = ""

lineBegin = 0
lineEnd = 0
lineNum = 0

fileObj = Commands.new #create a new object using the commands class

while command != "q" do #loop for user input || if input is q, exit the program
  puts("Enter a command")
  command = gets.chomp
  if command == "o"
    while readfile[lineEnd] != "\n" do #loop through file until a linebreak is found
      lineEnd += 1
    end
    #print(readfile[lineBegin,lineEnd])
    fileObj.readALine(readfile[lineBegin,lineEnd]) #sends the line found to the readALine method from Commands
    lineBegin = lineEnd+1 #moves over to the next line
    lineEnd = lineBegin #sets lineEnd to the beginning of the next line so the while loop can increment it again
    lineNum += 1
    if fileObj.wasIf == true
      while lineNum < fileObj.ifNum
        while readfile[lineEnd] != "\n" do #loop through file until a linebreak is found
          lineEnd += 1
        end
        lineBegin = lineEnd+1 #moves over to the next line
        lineEnd = lineBegin
        lineNum += 1
      end
    end
  elsif command == "a"
    while readfile[lineEnd] != nil do
      while readfile[lineEnd] != "\n" do #loop through file until a linebreak is found
        lineEnd += 1
      end
      #print(readfile[lineBegin,lineEnd])
      fileObj.readALine(readfile[lineBegin,lineEnd]) #sends the line found to the readALine method from Commands
      lineBegin = lineEnd+1 #moves over to the next line
      lineEnd = lineBegin #sets lineEnd to the beginning of the next line so the while loop can increment it again
    end
  end
end