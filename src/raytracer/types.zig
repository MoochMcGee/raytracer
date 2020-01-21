const rmath = @import("../rmath/rmath.zig");
const std = @import("std");
const Allocator = std.mem.Allocator;

pub const RGBAPixelU8 = packed struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,
};

pub const ImageRGBAU8 = struct {
    width: u32,
    height: u32,
    pixels: []RGBAPixelU8,
    allocator: *Allocator,
    pub fn init(allocator: *Allocator, width: u32, height: u32) !@This() {
        const pixels = try allocator.alloc(RGBAPixelU8, width * height);
        return @This(){ .width = width, .height = height, .pixels = pixels, .allocator = allocator };
    }
    pub fn deinit(self: *@This()) void {
        self.allocator.free(self.pixels);
    }
};

pub const Sphere = struct {
    center: rmath.Vec3F32,
    radius: f32,
    pub fn hit(self: @This(), ray: rmath.Ray) bool {
        const sphere_relative_ray_pos = ray.pos.sub(self.center);
        const a = ray.dir.dot(ray.dir);
        const b = 2 * sphere_relative_ray_pos.dot(ray.dir);
        const c = sphere_relative_ray_pos.dot(sphere_relative_ray_pos) - self.radius * self.radius;

        const discriminant = b * b - 4 * a * c;

        return (discriminant > 0);
    }
};
