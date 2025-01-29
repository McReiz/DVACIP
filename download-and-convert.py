import os
import math
import subprocess
from yt_dlp import YoutubeDL
from pydub import AudioSegment

import sys
sys.stdout.reconfigure(encoding='utf-8')

VIDEO_URL = input("Youtube URL: ")
folder_name = input("Folder name: ")

# Configuration

OUTPUT_VIDEO = "./outputs/"+folder_name+"/video.mp4"
OUTPUT_AUDIO = "./outputs/"+folder_name+"/audio.wav"
AMPLIFIED_AUDIO = "./outputs/"+folder_name+"/audio_amplified.wav"
CLIPS_FOLDER = "./outputs/"+folder_name+"/clips"
MAX_DURATION = 30 * 1000  # 30 seconds in milliseconds
AMPLIFICATION_DB = 3  # Approximately 30% increase in volume
FFMPEG_PATH = os.path.join(os.getcwd(), "ffmpeg.exe")  # ffmpeg path in the same folder

# Ensure the clips folder exists
os.makedirs(CLIPS_FOLDER, exist_ok=True)

# Step 1: Download YouTube video in MP4 format
def download_video(url, output_path):
    ydl_opts = {
        'format': 'bestvideo+bestaudio/best',
        'outtmpl': output_path
    }
    with YoutubeDL(ydl_opts) as ydl:
        ydl.download([url])
    print("[✔] Success Video Download.")

# Step 2: Convert to WAV using ffmpeg
def convert_to_wav(input_file, output_file):
    cmd = f'"{FFMPEG_PATH}" -i "{input_file}" -ac 2 -ar 44100 "{output_file}" -y'
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    
    if not os.path.exists(output_file):
        print("[❌] ERROR: WAV file not generated.")
        exit()
    
    print("[✔] Conversion to WAV completed.")

# Step 3: Amplify the sound
def amplify_audio(input_file, output_file, gain_dB):
    audio = AudioSegment.from_wav(input_file)
    amplified_audio = audio + gain_dB
    amplified_audio.export(output_file, format="wav")
    print("[✔] Audio amplified correctly.")

# Step 4: Split the audio into equal parts (but no more than 30s per clip)
def split_audio(input_file, output_folder, max_segment_duration):
    audio = AudioSegment.from_wav(input_file)
    total_duration = len(audio)
    
    num_segments = math.ceil(total_duration / max_segment_duration)
    segment_duration = total_duration // num_segments  # Divide into equal parts
    
    for i in range(num_segments):
        start_time = i * segment_duration
        end_time = min(start_time + segment_duration, total_duration)
        clip = audio[start_time:end_time]
        clip.export(os.path.join(output_folder, f"clip_{i+1}.wav"), format="wav")
        print(f"[✔] Clip {i+1} duration : ({segment_duration / 1000:.2f} seconds).")

# Ejecutar procesos
download_video(VIDEO_URL, OUTPUT_VIDEO)
convert_to_wav(OUTPUT_VIDEO, OUTPUT_AUDIO)
amplify_audio(OUTPUT_AUDIO, AMPLIFIED_AUDIO, AMPLIFICATION_DB)
split_audio(AMPLIFIED_AUDIO, CLIPS_FOLDER, MAX_DURATION)


print("[✅] Process completed successfully.")

input("Press Enter to continue...")