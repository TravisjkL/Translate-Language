require_relative 'LL.rb'

class Commands
  attr_reader :lineNum
  @@identifiers = Hash.new

  def initialize
    @lineNum = 0
    @isIF = false
  end

  def readALine(line)
    @isIF = false
    linePlace = 0
    while line[linePlace] != nil do #Iterate through the line to the end of the first command statement (excluding the variables)
      linePlace += 1
      if line[linePlace] == " "
        break
      end
    end
    #Checks which command is being called
    if line[0, linePlace].upcase == "VARINT"
      self.varint(line, @@identifiers, linePlace)
    end
    if line[0, linePlace].upcase == "VARLIST"
      self.varlist(line, @@identifiers, linePlace)
    end
    if line[0, linePlace].upcase == "COMBINE"
      self.combine(line, @@identifiers, linePlace)
    end
    if line[0, linePlace].upcase == "GET"
      self.getElement(line, @@identifiers, linePlace)
    end
    if line[0, linePlace].upcase == "SET"
      self.setElement(line, @@identifiers, linePlace)
    end
    if line[0, linePlace].upcase == "COPY"
      self.copy(line, @@identifiers, linePlace)
    end
    if line[0, linePlace].upcase == "CHS"
      self.chs(line, @@identifiers, linePlace)
    end
    if line[0, linePlace].upcase == "ADD"
      self.ifElement(line, @@identifiers, linePlace)
    end
    if line[0, linePlace].upcase == "IF"
      self.ifElement(line, @@identifiers, linePlace)
    end
    if line[0, linePlace].upcase == "HLT"
      exit
    end

    @lineNum += 1
  end


  #Assigns an integer to a variable
  def varint(line, identifiers, linePlace)
    linePlace += 1
    varBegin = linePlace
    #Loop through the remainder of the string to find the variable name
    while line[linePlace] != " " do
      linePlace += 1
    end
    varName = line[varBegin, linePlace - varBegin] #Start at varBegin, and subtract linePlace from varBegin to get the number of chars between the two
    #Continue looping to find variable value
    linePlace += 1
    varBegin = linePlace

    while line[linePlace] != nil do
      linePlace += 1
    end

    varVal = line[varBegin, linePlace - varBegin]

    #add the value and variable into the hash
    identifiers[varName] = varVal.to_i
  end


  #assigns a list to a variable y
  def varlist(line, identifiers, linePlace)
    linePlace += 1
    varBegin = linePlace
    while line[linePlace] != " " do
      linePlace += 1
    end
    varName = line[varBegin, linePlace - varBegin]
    aList = LinkedList.new
    varBegin = linePlace

     while line[linePlace] != nil do #Loop through the rest of the line
       if line[linePlace] == "," #whenever a comma is found, skip it and the following white space
         linePlace += 1
       end
       aList.add(line[varBegin, linePlace - varBegin].to_i) #add the integers into the linked list after converting them into integers
       linePlace += 1
    end

    identifiers[varName] = aList
  end

  def combine(line, identifiers, linePlace)
    linePlace += 1
    varBegin = linePlace
    #Iterate through the line to find the first list name
    while line[linePlace] != " " do
      linePlace += 1
    end
    varName = line[varBegin, linePlace - varBegin]
    list1 = identifiers.fetch(varName)

    varBegin = linePlace
    linePlace += 1
    while line[linePlace] != " " do #Iterate the line to find the second list name
      linePlace += 1
    end
    varName = line[varBegin, linePlace - varBegin]
    list2 = identifiers.fetch(varName)

    while list1.value != nil do
      list2.add(list1.value)
      list1 = list1.next
    end

    identifiers[varName] = list2

  end


  def getElement(line, identifiers, linePlace)
    linePlace += 1
    varBegin = linePlace
    #Iterate through the line to find the variable name
    while line[linePlace] != " " do
      linePlace += 1
    end
    varName = line[varBegin, linePlace - varBegin]

    linePlace += 1 #skip the white space
    #Iterate through line to find what number element the ith elemen would be
    while line[linePlace] != " " do
      linePlace += 1
    end
    ith = line[varBegin, linePlace - varBegin].to_i
    #Iterate through to the end of the line to get the list name
    while line[linePlace] != nil do
      linePlace += 1
    end
    aList = line[varBegin, linePlace - varBegin]
    tmpCount = 0 #A iterative counter

    while tmpCount < ith
      aList = aList.next
      tmpCount += 1
    end
    identifiers[varName] = aList.value
  end

  def setElement(line, identifiers, linePlace)
    linePlace += 1
    varBegin = linePlace
    #Iterate through the line to find the variable name
    while line[linePlace] != " " do
      linePlace += 1
    end
    varName = line[varBegin, linePlace - varBegin]

    linePlace += 1 #skip the white space
    #Iterate through line to find what number element the ith elemen would be
    while line[linePlace] != " " do
      linePlace += 1
    end
    ith = line[varBegin, linePlace - varBegin].to_i
    #Iterate through to the end of the line to get the list name
    while line[linePlace] != nil do
      linePlace += 1
    end
    aList = line[varBegin, linePlace - varBegin]
    tmpCount = 0 #A iterative counter

    #Iterate the ith number of times to reach the wanted position
    while tmpCount < ith
      aList = aList.next
      tmpCount += 1
    end
    aList.value = identifiers[varName] #set the value to whatever is stored at identifiers[varName]

  end


  def copy(line, identifiers, linePlace)
    linePlace += 1
    varBegin = linePlace
    #Iterate through the line to find the variable name
    while line[linePlace] != " " do
      linePlace += 1
    end
    list1 = line[varBegin, linePlace - varBegin]

    linePlace += 1
    varBegin = linePlace
    #Iterate through the line to find the second variable name
    while line[linePlace] != " " do
      linePlace += 1
    end
    list2 = line[varBegin, linePlace - varBegin]

    list1.next = list2

  end

  def chs(line, identifiers, linePlace)
    linePlace += 1
    varBegin = linePlace
    #Iterate through the line to find the variable name
    while line[linePlace] != " " do
      linePlace += 1
    end
    varName = line[varBegin, linePlace - varBegin]
    identifiers[varName] = identifiers[varName] * -1 #Go to the designated key and multiply it by negative 1 in order to flip it
  end

  def addElement(line, identifiers, linePlace)
    linePlace += 1
    varBegin = linePlace
    #Iterate through the line to find the variable name
    while line[linePlace] != " " do
      linePlace += 1
    end
    varOne = line[varBegin, linePlace - varBegin]

    linePlace += 1
    varBegin = linePlace
    #Iterate through the line to find the variable name
    while line[linePlace] != " " do
      linePlace += 1
    end
    varTwo = line[varBegin, linePlace - varBegin]

    identifiers[varOne] = identifiers[varOne] + identifiers[varTwo]
  end


  #Returns the line number
  def ifNum()
    @lineNum
  end

  #Return whether or not an if command was found
  def wasIf()
    @isIF
  end

  def ifElement(line, identifiers, linePlace)
    linePlace += 1
    varBegin = linePlace
    #Iterate through the line to find the variable name
    while line[linePlace] != " " do
      linePlace += 1
    end
    varName = line[varBegin, linePlace - varBegin]

    list = identifiers[varName]

    linePlace += 1
    varBegin = linePlace
    #Iterate through the line to find the i position
    while line[linePlace] != nil do
      linePlace += 1
    end
    ith = line[varBegin, linePlace - varBegin].to_i
    if (list.empty) or (list.value == 0) #Checks if the list is empty or it's the number zero
      @lineNum = ith-1
    end
    @isIF = true


  end
end
