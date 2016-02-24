local Peer = Class('Peer')

function Peer:Create(name)
  self.socket = require("socket")
  self.netPeers = {}
  self.port = 7253
  self.dns = self.socket.dns
  self.udp = self.socket.udp()
  self.udp:settimeout(self.timeout)
  self.peername = name -- TODO change to steamID
  self.P2P = false
  self.timeout = 0
end

function Peer:getSelfID()
  if self.peername then
    return ("$" .. self.Name .. "$" .. self.peername .. "$")
  else
    return ("$CLEINTFAIL$" .. self.peername .. "$")
    --    error("self.peername is not set. Please set self.peername")
  end
end
function Peer:Connect(addr,port)
  name, alias, ip = self.dns.toip(addr)
  if not ip then
    ip = addr
    print("IP returned nil, attempting direct addr connect.")
  end
  if self.Pinging then
    error("Connecting too quickly!")
  end
  if self.P2P then
    self.udp:sendto("ping" .. self:getSelfID(),ip,port)
    print("waiting for pong for 5 seconds")
    self.Pinging = {ip = ip, port = port, time = love.timer.getTime()}
  end
end

function Peer:sendToServer(data)
  if self.P2P then
    if self.server.connected then
      self.udp:sendto(data, self.server.ip, self.server.port)
    end
  else
    if self.udp:send(data) then
      return true
    end
    return
  end
end

function Peer:Discover()
  if self.udp:setoption('broadcast',true) then
    self.multicast = true
    local success, msg = self.udp:sendto("ping","255.255.255.255",self.port)
    if not success then
      --failed
      print("failed to broadcast: "..msg)
    end
  end
  send:setoption( "broadcast", false ) 
end

function Peer:Update()
  repeat -- do this once
    print(self.udp:getsockname())
    data,from,port = self.udp:receivefrom() -- from can also be an error message if port is nil
    if data then
      self.HandleData(data,from,port)
    else
      print("nothing to receive")
    end
  until not data -- and continue until there is no more data TODO: change this so that it will not take up more than X or just override
  if self.server.connected then
    udp.sendto("ping".. self:getSelfID())
  end
end

function Peer:HandleData(data,from,port)  
  if not from then print("from is nil") from = "" end
  if not port then print("port is nil") port = 7253 end
  if not data then print("data in nil") data = "" end
  print("port: " .. port .. ". from: " .. from .. ". data: " ..data)
  if port and from and data then 
    
    if self.Pinging then
      if self:handlePong() then 
        return
      end
    end -- if we are waiting for a response, then try and handle it, if we do handle it then return as we have nothing else to do with this packet type.
    
    if string.match(data,"ping") then
      self:handlePing(from,port)
    end
    print(from.. ": "..data)
    elseif from then -- if there was no port due to a network message being sent.
    print("error: " ..from ) -- print the message
  elseif data then
    print("error: " ..data)
  end
end

function Peer:handlePong(data,from,port)
  if self.Pinging then
    if string.match(data,"pong") and from == self.Pinging.ip and port == self.pining.port then 
      print(split(data,"$"))
      ping,ptype,pname = split(data,"$")
      table.insert(self.netpeers,Network.NetPeer(ip,port,ptype,name,false))
      
    end
  end
end

function Peer:handlePing(from,port)
  self.udp:sendto("pong" .. self:getSelfID(),from,port)
  print("Received ping from " .. from)
end
return Peer