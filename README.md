# Machine Learning with MATLAB

This repository contains a MATLAB-based Machine Learning Software (MLS) that is specifically designed for advanced biomedical signal processing applications. The software provides an intuitive graphical user interface (GUI) that facilitates users in efficiently processing and analyzing various complex biological signals. These include, but are not limited to, electroencephalography (EEG), electrocardiography (ECG), and electromyography (EMG). 

The MLS is equipped with a comprehensive set of tools that cater to different aspects of biomedical signal processing. One of the key features is filter design, which allows users to create and apply various types of filters to clean and preprocess the signals, ensuring the removal of noise and artifacts that could skew results.

In addition to filter design, the software offers capabilities for feature extraction, enabling users to identify and extract significant characteristics from the signals that are crucial for further analysis. This process is vital in preparing the data for subsequent steps, such as classification or pattern recognition.

The MLS also includes dimensionality reduction techniques that help simplify the data without losing essential information. This is particularly important in the context of high-dimensional data, as it enhances the efficiency of machine learning algorithms and makes visualization more manageable.

The software uses diverse machine learning algorithms, allowing users to customize techniques for classifying and analyzing biomedical signals, tailored to their research needs.

Overall, this MATLAB-based Machine Learning Software is a robust solution for researchers and practitioners in the field of biomedical signal processing, offering a comprehensive suite of tools designed for effective signal analysis and machine learning applications.

**Related Article**:  
[A muscle synergies-based movements detection approach for recognition of the wrist movements](https://link.springer.com/article/10.1186/s13634-020-00699-y)

## Demo
https://github.com/user-attachments/assets/f7e55365-ed98-4a4d-804a-cbe9011b3210

## Features

- **Data Preprocessing**: Import data from various formats (e.g., `.mat`, `.txt`, `.xlsx`), select channels, and apply denoising and filtering techniques.
- **Feature Extraction**: Extract features in both time and frequency domains using methods like Mean Absolute Value (MAV), Root Mean Square (RMS), and Wavelet transforms.
- **Feature Selection**: Utilize algorithms such as Principal Component Analysis (PCA), Fisher's Discriminate Analysis (FDA), and Mutual Information for optimal feature selection.
- **Classification & Clustering**: Apply supervised (e.g., SVM, KNN, MLP) machine learning algorithms.
- **Performance Evaluation**: Assess model performance using metrics like Accuracy, Sensitivity, Specificity, and F-score.

## Software Outline

1. **Step 1 & 2**: Import data, perform channel selection, and apply denoising and filtering (e.g., Notch Filter, Butterworth Filter).
2. **Step 3 & 4**: Extract features in time and frequency domains and select optimal features.
3. **Step 5**: Apply supervised machine learning techniques and assess their performance through different metrics.

## Abbreviations

- **Filtering**: Sampling frequency (Fs), lower cutoff frequency (Flow), higher cutoff frequency (Fhigh), Passband ripple (Rp), Stopband attenuation (Rs).
- **Feature Extraction**: Mean Absolute Value (MAV), Root Mean Square (RMS), Waveform length (WL), etc.
- **Feature Selection**: PCA, FDA, Mutual Information, etc.
- **Classification & Clustering**: SVM, KNN, MLP, K-means, etc.
- **Performance**: Accuracy, Sensitivity, Specificity, F-score, etc.

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/RezaSaadatyar/Machine-Learning-with-MATLAB.git
   ```
2. Open MATLAB and navigate to the cloned directory.
3. Run the `main.m` file to launch the graphical user interface.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any questions or support, please contact Reza.Saadatyar@outlook.com

