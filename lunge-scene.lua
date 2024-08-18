local Baton = require("libraries.baton")
local Vector = require("libraries.brinevector")

local InputManager = require('input-manager')

local LungeScene = {}
LungeScene.__index = LungeScene

function LungeScene.new()
    local self = {
        controls         = Baton.new({
            controls = {
                leftLegForward = { 'key:q' },
                leftLegBack = { 'key:a' },
                rightLegForward = { 'key:e' },
                rightLegBack = { 'key:d' },
            }
        }),
        images           = {
            head = love.graphics.newImage("assets/lunge/lunge-head.png"),
            body = love.graphics.newImage("assets/lunge/lunge-body.png"),
            leftUpperArm = love.graphics.newImage("assets/lunge/lunge-left-upper-arm.png"),
            leftLowerArm = love.graphics.newImage("assets/lunge/lunge-left-lower-arm.png"),
            leftUpperLeg = love.graphics.newImage("assets/lunge/lunge-left-upper-leg.png"),
            leftLowerLeg = love.graphics.newImage("assets/lunge/lunge-left-lower-leg.png"),
            rightUpperArm = love.graphics.newImage("assets/lunge/lunge-right-upper-arm.png"),
            rightLowerArm = love.graphics.newImage("assets/lunge/lunge-right-lower-arm.png"),
            rightUpperLeg = love.graphics.newImage("assets/lunge/lunge-right-upper-leg.png"),
            rightLowerLeg = love.graphics.newImage("assets/lunge/lunge-right-lower-leg.png"),
        },
        defaultPositions = {
            head = Vector(0, 0),
            body = Vector(-9, 4),
            leftUpperArm = Vector(-9, 3),
            leftLowerArm = Vector(-9, -5),
            leftUpperLeg = Vector(-3, -5),
            leftLowerLeg = Vector(-1, -3),
            rightUpperArm = Vector(25, 3),
            rightLowerArm = Vector(25, -5),
            rightUpperLeg = Vector(12, -5),
            rightLowerLeg = Vector(17, -3),
        },
        positions        = {
            head = Vector(0, 0),
            body = Vector(-9, 4),
            leftUpperArm = Vector(-9, 3),
            leftLowerArm = Vector(-9, -5),
            leftUpperLeg = Vector(-3, -5),
            leftLowerLeg = Vector(-1, -3),
            rightUpperArm = Vector(25, 3),
            rightLowerArm = Vector(25, -5),
            rightUpperLeg = Vector(12, -5),
            rightLowerLeg = Vector(17, -3),
        },
        leftLegEffort    = 0,
        rightLegEffort   = 0,
    }
    setmetatable(self, LungeScene)
    return self
end

function LungeScene:update(dt)
end

function LungeScene:draw()
    love.graphics.push()
    love.graphics.translate(160, 80)
    love.graphics.draw(
        self.images.rightLowerLeg,
        self.positions.rightLowerLeg.x,
        self.positions.rightLowerLeg.y)
    love.graphics.draw(
        self.images.leftLowerLeg,
        self.positions.leftLowerLeg.x,
        self.positions.leftLowerLeg.y)
    love.graphics.draw(
        self.images.rightUpperLeg,
        self.positions.rightUpperLeg.x,
        self.positions.rightUpperLeg.y)
    love.graphics.draw(
        self.images.leftUpperLeg,
        self.positions.leftUpperLeg.x,
        self.positions.leftUpperLeg.y)
    love.graphics.draw(
        self.images.rightLowerArm,
        self.positions.rightLowerArm.x,
        self.positions.rightLowerArm.y)
    love.graphics.draw(
        self.images.leftLowerArm,
        self.positions.leftLowerArm.x,
        self.positions.leftLowerArm.y)
    love.graphics.draw(
        self.images.rightUpperArm,
        self.positions.rightUpperArm.x,
        self.positions.rightUpperArm.y)
    love.graphics.draw(
        self.images.leftUpperArm,
        self.positions.leftUpperArm.x,
        self.positions.leftUpperArm.y)
    love.graphics.draw(
        self.images.body,
        self.positions.body.x,
        self.positions.body.y)
    love.graphics.draw(
        self.images.head,
        self.positions.head.x,
        self.positions.head.y)
    love.graphics.pop()
end

return LungeScene
