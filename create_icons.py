from PIL import Image
import os

# Paths
logo_path = 'assets/images/logo.png'
foreground_output = 'assets/images/logo_adaptive_foreground.png'
ios_output = 'assets/images/logo_ios.png'

# Ensure the logo exists
if not os.path.exists(logo_path):
    print(f"Logo file not found: {logo_path}")
    exit(1)

# Open the logo
logo = Image.open(logo_path).convert('RGBA')

# Get original size
orig_width, orig_height = logo.size

# Android Adaptive Icon Foreground: 1024x1024 with padding
android_size = 1024
# Key artwork within inner 66-72%, so padding around 14-17% on each side
# Let's use 16% padding
padding_percent = 0.16
padding = int(android_size * padding_percent)
inner_size = android_size - 2 * padding

# Resize logo to fit within inner area
logo_resized = logo.resize((inner_size, inner_size), Image.Resampling.LANCZOS)

# Create new image with transparent background
android_img = Image.new('RGBA', (android_size, android_size), (0, 0, 0, 0))

# Paste the resized logo with padding
android_img.paste(logo_resized, (padding, padding), logo_resized)

# Save Android foreground
android_img.save(foreground_output)
print(f"Android foreground saved: {foreground_output}")

# iOS Icon: Also padded a bit, assuming 1024x1024 for high res
ios_size = 1024
# Pad a bit, say 5% on each side
ios_padding_percent = 0.05
ios_padding = int(ios_size * ios_padding_percent)
ios_inner_size = ios_size - 2 * ios_padding

# Resize logo
ios_logo_resized = logo.resize((ios_inner_size, ios_inner_size), Image.Resampling.LANCZOS)

# Create new image
ios_img = Image.new('RGBA', (ios_size, ios_size), (0, 0, 0, 0))

# Paste
ios_img.paste(ios_logo_resized, (ios_padding, ios_padding), ios_logo_resized)

# Save iOS icon
ios_img.save(ios_output)
print(f"iOS icon saved: {ios_output}")
