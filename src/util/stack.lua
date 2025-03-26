Stack = {}

function Stack:new()
	local stack = {}
	setmetatable(stack, { __index = self })

	stack.data = {}

	return stack
end

-- Push element onto the stack
function Stack:push(element)
  table.insert(self.data, element)
end

-- Pop element from the stack (removes and returns the top element)
function Stack:pop()
  if #self.data == 0 then
    return nil -- Handle empty stack case
  else
    local topElement = self.data[#self.data]
    table.remove(self.data, #self.data)
    return topElement
  end
end

-- Peek at the top element without removing it
function Stack:peek()
  if #self.data == 0 then
    return nil -- Handle empty stack case
  else
    return self.data[#self.data]
  end
end

-- Check if the stack is empty
function Stack:empty()
  return #self.data == 0
end

-- Get the size of the stack
function Stack:size()
  return #self.data
end

return Stack
