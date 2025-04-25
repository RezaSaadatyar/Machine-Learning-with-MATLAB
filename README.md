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
- **Feature Selection**: Utilize algorithms such as Principal Component Analysis (PCA), Fisher's Discriminant Analysis (FDA), and Mutual Information for optimal feature selection.
- **Classification**: Apply supervised (e.g., SVM, KNN, MLP) machine learning algorithms.
- **Performance Evaluation**: Assess model performance using metrics like Accuracy, Sensitivity, Specificity, and F-score.

## What do you Learn
- The importance of data preprocessing in ensuring the quality and relevance of the data used for analysis.
- Various methods of feature extraction and how they can provide insights into the underlying patterns of the data.
- The significance of feature selection techniques in improving model performance and reducing computational complexity.
- The application of different classification algorithms and their suitability for various types of data and problems.
- The critical role of performance evaluation metrics in assessing the effectiveness of machine learning models.

## Software Outline

1. **Step 1 & 2**: Import data, perform channel selection, and apply denoising and filtering (e.g., Notch Filter, Butterworth Filter).
2. **Step 3 & 4**: Extract features in time and frequency domains and select optimal features.
3. **Step 5**: Apply supervised machine learning techniques and assess their performance through different metrics.

## Data Preparation

### Data Formats
The software supports the following data formats for classification:
1. **MAT Files (`.mat`)**:
   - You can merge inputs (data) and labels (targets) into a single `.mat` file.
   - Example: Save your data as `data_inputs_labels.mat`, where:
     - `inputs` contains the feature data (e.g., a matrix of size `[samples x features]`).
     - `labels` contains the corresponding labels (e.g., a vector of size `[samples x 1]`).

2. **Text Files (`.txt`)** or **Excel Files (`.xlsx`)**:
   - Ensure that the inputs and labels are clearly separated into specific columns or channels.
   - You must know which columns or channels correspond to the inputs and which correspond to the labels.
   - Example for `.txt` or `.xlsx`:
     - Column 1 to N: Input features (e.g., signal data).
     - Column N+1: Labels (e.g., class labels).

## Abbreviations

- **Filtering**: Sampling frequency (Fs), Lower cutoff frequency (Flow), Higher cutoff frequency (Fhigh), Passband ripple (Rp), Stopband attenuation (Rs).
- **Feature Extraction**: Mean Absolute Value (MAV), Root Mean Square (RMS), Waveform length (WL), etc.
- **Feature Selection**: PCA, FDA, Mutual Information, etc.
- **Classification**: SVM, KNN, MLP, etc.
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

