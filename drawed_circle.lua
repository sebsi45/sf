local client = {}
local RunService = game:GetService("RunService")
function client.renderCircle(Point, Radius)
   local Circle = {}

   local points = {}
   local lines = {}

   function Circle.Destroy()
       Circle.Stepped:Disconnect()
       for i,v in ipairs(lines) do
           if rawget(v, "__OBJECT_EXISTS") then
               v:Remove()
           end
       end
       for i,v in ipairs(points) do
           points[i] = nil
       end
   end

   local ixAxis = Point.X
   local iyAxis = Point.Y
   local izAxis = Point.Z

   for i = 0, 360, 10 do
       local xOffset = ixAxis + Radius * cos(rad(i))
       local zOffset = izAxis + Radius * sin(rad(i))
       local Result = nVector3(xOffset, iyAxis, zOffset)

       insert(points, Result)
   end

   for _,v in ipairs(points) do
       local line = framework("draw", {hidden = true, class = "Line", properties = {
           Visible = true,
           Transparency = 1,
           Color = Color3.new(1,1,1),
           Thickness = 1,
       }})
       insert(lines, line)
   end

   Circle.Stepped = RunService.RenderStepped:Connect(function()
       local xAxis = Point.X
       local yAxis = Point.Y
       local zAxis = Point.Z

       for i,v in ipairs(points) do
           points[i] = nil
       end

       for i = 0, 360, 10 do
           local xOffset = xAxis + Radius * cos(rad(i))
           local zOffset = zAxis + Radius * sin(rad(i))
           local Result = nVector3(xOffset, yAxis, zOffset)
   
           insert(points, Result)
       end

       for i,v in ipairs(lines) do
           local nextPoint = points[i+1]
           if nextPoint ~= nil then
               local currentPointPosition,isCurrentVisible = client.returnCamera().WorldToViewportPoint(client.returnCamera(),points[i])
               local nextPointPosition,isNextVisible = client.returnCamera().WorldToViewportPoint(client.returnCamera(),nextPoint)
               if not isCurrentVisible and not isNextVisible then
                   if rawget(v, "__OBJECT_EXISTS") then
                       v.Visible = false
                   end
               else
                   if rawget(v, "__OBJECT_EXISTS") then
                       v.Visible = true
                       v.From = nVector2(currentPointPosition.X,currentPointPosition.Y)
                       v.To = nVector2(nextPointPosition.X,nextPointPosition.Y)
                   end
               end
           end
       end
   end)
   return Circle
end

return client
